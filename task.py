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
from PIL import ImageFilter
from PIL import ImageSequence

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
            cmd = (
                define.RE_PATH,
                '-v',
                '-i', inputPath,
                '-o', outputPath,
                '-s', str(self.config.modelFactor),
                '-t', str(self.config.tileSize),
                '-n', self.config.model,
                '-g', 'auto' if self.config.gpuID < 0 else str(self.config.gpuID),
                ('-x' if self.config.useTTA else ''),
            )
            with subprocess.Popen(
                cmd,
                stderr=subprocess.PIPE,
                universal_newlines=True,
                creationflags=subprocess.CREATE_NO_WINDOW if os.name == 'nt' else 0,
            ) as p:
                for line in p.stderr:
                    self.outputCallback(line)
            if p.returncode:
                raise subprocess.CalledProcessError(p.returncode, cmd)
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
        optimizeTransparency: bool,
    ) -> None:
        super().__init__(outputCallback)
        self.outputPath = outputPath
        self.frames = frames
        self.durations = durations
        self.optimizeTransparency = optimizeTransparency

    def run(self) -> None:
        self.outputCallback(f'Merging {len(self.frames)} frames to {self.outputPath}\n')
        frameImgs: list[Image.Image] = []
        for f in self.frames:
            b = io.BytesIO()
            with Image.open(f) as img:
                if self.optimizeTransparency:
                    # LUT from Photoshop curve: (209, 182) (237, 245)
                    img.putalpha(img.split()[-1].filter(ImageFilter.GaussianBlur(3)).point((
                        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
                        0x00, 0x00, 0x00, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01, 0x01,
                        0x01, 0x01, 0x01, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x02, 0x03, 0x03, 0x03, 0x03,
                        0x03, 0x03, 0x03, 0x04, 0x04, 0x04, 0x04, 0x04, 0x05, 0x05, 0x05, 0x05, 0x05, 0x06, 0x06, 0x06,
                        0x06, 0x07, 0x07, 0x07, 0x07, 0x08, 0x08, 0x08, 0x09, 0x09, 0x09, 0x0A, 0x0A, 0x0A, 0x0B, 0x0B,
                        0x0C, 0x0C, 0x0C, 0x0D, 0x0D, 0x0E, 0x0E, 0x0F, 0x0F, 0x10, 0x10, 0x10, 0x11, 0x12, 0x12, 0x13,
                        0x13, 0x14, 0x14, 0x15, 0x15, 0x16, 0x17, 0x17, 0x18, 0x19, 0x19, 0x1A, 0x1B, 0x1B, 0x1C, 0x1D,
                        0x1E, 0x1E, 0x1F, 0x20, 0x21, 0x22, 0x22, 0x23, 0x24, 0x25, 0x26, 0x27, 0x28, 0x29, 0x29, 0x2A,
                        0x2B, 0x2C, 0x2D, 0x2E, 0x2F, 0x30, 0x32, 0x33, 0x34, 0x35, 0x36, 0x37, 0x38, 0x39, 0x3B, 0x3C,
                        0x3D, 0x3E, 0x40, 0x41, 0x42, 0x43, 0x45, 0x46, 0x47, 0x49, 0x4A, 0x4C, 0x4D, 0x4F, 0x50, 0x51,
                        0x53, 0x55, 0x56, 0x58, 0x59, 0x5B, 0x5C, 0x5E, 0x60, 0x61, 0x63, 0x65, 0x67, 0x68, 0x6A, 0x6C,
                        0x6E, 0x70, 0x71, 0x73, 0x75, 0x77, 0x79, 0x7B, 0x7D, 0x7F, 0x81, 0x83, 0x85, 0x87, 0x89, 0x8C,
                        0x8E, 0x90, 0x92, 0x94, 0x97, 0x99, 0x9B, 0x9D, 0xA0, 0xA2, 0xA5, 0xA7, 0xA9, 0xAC, 0xAE, 0xB1,
                        0xB3, 0xB6, 0xB9, 0xBB, 0xBE, 0xC0, 0xC3, 0xC6, 0xC8, 0xCB, 0xCE, 0xD0, 0xD3, 0xD5, 0xD8, 0xDA,
                        0xDC, 0xDF, 0xE1, 0xE3, 0xE5, 0xE8, 0xEA, 0xEB, 0xED, 0xEF, 0xF1, 0xF2, 0xF4, 0xF5, 0xF6, 0xF7,
                        0xF8, 0xF9, 0xFA, 0xFB, 0xFB, 0xFC, 0xFC, 0xFD, 0xFD, 0xFE, 0xFE, 0xFE, 0xFE, 0xFF, 0xFF, 0xFF,
                    )).convert('1'))
                img.save(b, 'gif')
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
        optimizeTransparency: bool,
    ) -> None:
        super().__init__(outputCallback)
        self.inputPath = inputPath
        self.outputPath = outputPath
        self.config = config
        self.queue = queue
        self.optimizeTransparency = optimizeTransparency

    def run(self) -> None:
        frames = []
        durations = []
        tasks = []
        with Image.open(self.inputPath) as img:
            for f in ImageSequence.Iterator(img):
                f: Image.Image
                frameSrcPath = buildTempPath('.png' if self.optimizeTransparency else '.webp')
                frameDstPath = buildTempPath('.png' if self.optimizeTransparency else '.webp')
                d = f.info.get('duration', 0)
                if self.optimizeTransparency:
                    f = f.convert('RGBA')
                    with Image.new('RGBA', img.size, (255, 255, 255, 255)) as g:
                        g.alpha_composite(f)
                        g.putalpha(f.split()[-1])
                        g.save(frameSrcPath, lossless=True)
                else:
                    f.save(frameSrcPath, lossless=True)
                self.outputCallback(f'Frame #{len(frames)}: {frameSrcPath} -> {frameDstPath} Duration: {d}\n')
                frames.append(frameDstPath)
                durations.append(d)
                tasks.append(RESpawnTask(self.outputCallback, frameSrcPath, frameDstPath, self.config, True))
        tasks.append(MergeGIFTask(self.outputCallback, self.outputPath, frames, durations, self.optimizeTransparency))
        tasks.reverse()
        for t in tasks:
            self.queue.appendleft(t)

class LossyCompressTask(AbstractTask):
    def __init__(
        self,
        outputCallback: typing.Callable[[str], None],
        inputPath: str, outputPath: str,
        quality: int,
        removeInput: bool = False,
    ) -> None:
        super().__init__(outputCallback)
        self.inputPath = inputPath
        self.outputPath = outputPath
        self.quality = quality
        self.removeInput = removeInput

    def run(self) -> None:
        self.outputCallback(f'Compressing {self.inputPath} to {self.outputPath} with quality {self.quality}\n')
        os.makedirs(os.path.split(self.outputPath)[0], exist_ok=True)
        with Image.open(self.inputPath) as img:
            match os.path.splitext(self.outputPath)[1].lower():
                case '.webp':
                    img.save(self.outputPath, quality=self.quality, method=6)
                case '.jpg' | '.jpeg':
                    img.save(self.outputPath, quality=self.quality, optimize=True, progressive=True)
        if self.removeInput:
            os.remove(self.inputPath)

def taskRunner(
    queue: collections.deque[AbstractTask],
    outputCallback: typing.Callable[[str], None],
    completeCallback: typing.Callable[[bool], None],
    failCallback: typing.Callable[[Exception], None],
    finallyCallback: typing.Callable[[], None],
    ignoreError: bool,
) -> None:
    counter = 0
    withError = False
    while queue:
        try:
            ts = time.perf_counter()
            queue.popleft().run()
            te = time.perf_counter()
            outputCallback(f'Task #{counter} completed in {round((te - ts) * 1000)}ms.\n')
            counter += 1
        except Exception as ex:
            withError = True
            outputCallback(traceback.format_exc())
            failCallback(ex)
            if not ignoreError:
                finallyCallback()
                return
    completeCallback(withError)
    finallyCallback()