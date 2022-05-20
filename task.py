import collections
import secrets
import subprocess
import io
import os
import shutil
import tempfile
import time
import traceback
import typing
from PIL import Image

import define
import param

def buildTempPath(ext: str) -> str:
    return os.path.join(tempfile.gettempdir(), secrets.token_urlsafe(12) + ext)

class AbstractTask:
    def __init__(self, outputCallback: typing.Callable[[str], None]) -> None:
        self.outputCallback = outputCallback

    def run(self) -> None:
        pass

class RESpawnTask(AbstractTask):
    def __init__(
        self,
        outputCallback: typing.Callable[[str], None],
        inputPath: str, outputPath: str,
        config: param.REConfigParams,
        removeInput: bool = False,
    ) -> None:
        super().__init__(outputCallback)
        self.inputPath = inputPath
        self.outputPath = outputPath
        self.config = config
        self.removeInput = removeInput

    def run(self) -> None:
        self.outputCallback(f'Using executable: {define.RE_PATH}\n')

        with Image.open(self.inputPath) as img:
            srcWidth, srcHeight = img.size
            srcRatio = srcWidth / srcHeight
            if img.mode == 'P':
                self.inputPath = buildTempPath('.png')
                img.convert('RGBA').save(self.inputPath)
                self.removeInput = True
        match self.config.resizeMode:
            case param.ResizeMode.RATIO:
                dstWidth = srcWidth * self.config.resizeModeValue
                dstHeight = srcHeight * self.config.resizeModeValue
            case param.ResizeMode.WIDTH:
                dstWidth = self.config.resizeModeValue
                dstHeight = round(dstWidth / srcRatio)
            case param.ResizeMode.HEIGHT:
                dstHeight = self.config.resizeModeValue
                dstWidth = round(dstHeight * srcRatio)
        scalePass = 0
        while srcWidth < dstWidth and srcHeight < dstHeight:
            scalePass += 1
            srcWidth *= self.config.modelFactor
            srcHeight *= self.config.modelFactor

        # input -> output
        # input -> temp0 -> output
        # input -> temp0 -> temp1 -> output
        outputExt = os.path.splitext(self.outputPath)[1]
        files = (self.inputPath, *(buildTempPath(outputExt) for _ in range(scalePass)))
        for i in range(len(files) - 1):
            inputPath, outputPath = files[i:(i + 2)]
            with subprocess.Popen(
                (
                    define.RE_PATH,
                    '-v',
                    '-i', inputPath,
                    '-o', outputPath,
                    '-s', str(self.config.modelFactor),
                    '-t', str(self.config.tileSize),
                    '-n', self.config.model,
                    '-g', str(self.config.gpuID),
                    ('-x' if self.config.useTTA else ''),
                ),
                stderr=subprocess.PIPE,
                universal_newlines=True,
                creationflags=subprocess.CREATE_NO_WINDOW if os.name == 'nt' else 0,
            ) as p:
                for line in p.stderr:
                    self.outputCallback(line)
            if p.returncode:
                raise subprocess.CalledProcessError(p.returncode)
            if i > 0 or self.removeInput:
                os.remove(inputPath)

        os.makedirs(os.path.split(self.outputPath)[0], exist_ok=True)
        if srcWidth == dstWidth and srcHeight == dstHeight:
            if os.path.exists(self.outputPath):
                os.remove(self.outputPath)
            shutil.move(files[-1], self.outputPath)
        else:
            with Image.open(files[-1]) as img:
                self.outputCallback(f'Downsample from {img.size[0]}x{img.size[1]} to {dstWidth}x{dstHeight}.\n')
                resized: Image.Image = img.resize((dstWidth, dstHeight), self.config.downsample)
                resized.save(self.outputPath)
                resized.close()
            os.remove(files[-1])

class MergeGIFTask(AbstractTask):
    def __init__(
        self,
        outputCallback: typing.Callable[[str], None],
        outputPath: str,
        frames: tuple[str, ...],
        durations: tuple[int, ...],
    ) -> None:
        super().__init__(outputCallback)
        self.outputPath = outputPath
        self.frames = frames
        self.durations = durations

    def run(self) -> None:
        self.outputCallback(f'Merging {len(self.frames)} frames to {self.outputPath}\n')
        frameImgs: list[Image.Image] = []
        for f in self.frames:
            b = io.BytesIO()
            Image.open(f).save(b, 'gif')
            os.remove(f)
            img = Image.open(b)
            if 'transparency' in img.info:
                paletteMap = list(range(256))
                paletteMap[0], paletteMap[img.info['transparency']] = paletteMap[img.info['transparency']], paletteMap[0]
                img = img.remap_palette(paletteMap)
                img.info['transparency'] = 0
            frameImgs.append(img)
        os.makedirs(os.path.split(self.outputPath)[0], exist_ok=True)
        frameImgs[0].save(self.outputPath, save_all=True, optimize=True, loop=0, duration=self.durations, append_images=frameImgs[1:], disposal=2)

class SplitGIFTask(AbstractTask):
    def __init__(
        self,
        outputCallback: typing.Callable[[str], None],
        inputPath: str, outputPath: str,
        config: param.REConfigParams,
        queue: collections.deque[AbstractTask],
    ) -> None:
        super().__init__(outputCallback)
        self.inputPath = inputPath
        self.outputPath = outputPath
        self.config = config
        self.queue = queue

    def run(self) -> None:
        frames = []
        durations = []
        tasks = []
        with Image.open(self.inputPath) as img:
            while True:
                try:
                    frameSrcPath = buildTempPath('.webp')
                    frameDstPath = buildTempPath('.webp')
                    img.save(frameSrcPath, lossless=True)
                    d = img.info['duration']
                    self.outputCallback(f'Frame #{len(frames)}: {frameSrcPath} -> {frameDstPath} Duration: {d}\n')
                    frames.append(frameDstPath)
                    durations.append(d)
                    tasks.append(RESpawnTask(self.outputCallback, frameSrcPath, frameDstPath, self.config, True))
                    img.seek(img.tell() + 1)
                except EOFError:
                    break
        tasks.append(MergeGIFTask(self.outputCallback, self.outputPath, frames, durations))
        tasks.reverse()
        for t in tasks:
            self.queue.appendleft(t)

def taskRunner(
    queue: collections.deque[AbstractTask],
    outputCallback: typing.Callable[[str], None],
    completeCallback: typing.Callable[[], None],
) -> None:
    counter = 0
    try:
        while queue:
            ts = time.perf_counter()
            queue.popleft().run()
            te = time.perf_counter()
            outputCallback(f'Task #{counter} completed in {round((te - ts) * 1000)}ms.\n')
            counter += 1
    except:
        outputCallback(traceback.format_exc())
    finally:
        completeCallback()