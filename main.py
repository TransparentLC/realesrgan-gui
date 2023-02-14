import collections
import configparser
import notifypy
import os
import sys
import time
import threading
import tkinter as tk
import traceback
import webbrowser
from PIL import Image
from PIL import ImageTk
from tkinter import filedialog
from tkinter import messagebox
from tkinter import ttk
from tkinter.scrolledtext import ScrolledText
from tkinterdnd2 import DND_FILES
from tkinterdnd2 import TkinterDnD

import define
import i18n
import param
import task

class REGUIApp(ttk.Frame):
    def __init__(self, parent: tk.Tk):
        super().__init__(parent)
        modelFiles = set(os.listdir(os.path.join(define.APP_PATH, 'models')))
        self.models = sorted(
            x for x in set(os.path.splitext(y)[0] for y in modelFiles)
            if f'{x}.bin' in modelFiles and f'{x}.param' in modelFiles
        )
        for m in (
            'realesrgan-x4plus',
            'realesrgan-x4plus-anime',
        )[::-1]:
            try:
                self.models.insert(0, self.models.pop(self.models.index(m)))
            except ValueError:
                pass
        self.modelFactors: dict[str, int] = {}
        for m in self.models:
            self.modelFactors[m] = 4
            for i in range(2, 5):
                if f'x{i}' in m:
                    self.modelFactors[m] = i
                    break

        self.downsample = (
            ('Lanczos', Image.Resampling.LANCZOS),
            ('Bicubic', Image.Resampling.BICUBIC),
            ('Hamming', Image.Resampling.HAMMING),
            ('Bilinear', Image.Resampling.BILINEAR),
            ('Box', Image.Resampling.BOX),
            ('Nearest', Image.Resampling.NEAREST),
        )
        self.tileSize = (0, 32, 64, 128, 256, 512, 1024)

        self.config = configparser.ConfigParser({
            'ResizeMode': int(param.ResizeMode.RATIO),
            'ResizeRatio': 4,
            'ResizeWidth': 1024,
            'ResizeHeight': 1024,
            'Model': self.models[0],
            'DownsampleIndex': 0,
            'GPUID': 0,
            'TileSizeIndex': 0,
            'LossyQuality': 80,
            'UseWebP': False,
            'UseTTA': False,
            'OptimizeGIF': False,
            'LossyMode': False,
        })
        self.config['Config'] = {}
        self.config.read(define.APP_CONFIG_PATH)

        self.outputPathChanged = True

        self.setupVars()
        self.setupWidgets()

    def setupVars(self):
        def varstrOutputPathCallback(var: tk.IntVar | tk.StringVar, index: str, mode: str):
            self.outputPathChanged = True
        def outputPathTraceCallback(var: tk.IntVar | tk.StringVar, index: str, mode: str):
            if not self.outputPathChanged:
                self.setInputPath(self.varstrInputPath.get())
        self.varstrInputPath = tk.StringVar()
        self.varstrOutputPath = tk.StringVar()
        self.varstrOutputPath.trace_add('write', varstrOutputPathCallback)
        self.varintResizeMode = tk.IntVar(value=self.config['Config'].getint('ResizeMode'))
        self.varintResizeMode.trace_add('write', outputPathTraceCallback)
        self.varintResizeRatio = tk.IntVar(value=self.config['Config'].getint('ResizeRatio'))
        self.varintResizeRatio.trace_add('write', outputPathTraceCallback)
        self.varintResizeWidth = tk.IntVar(value=self.config['Config'].getint('ResizeWidth'))
        self.varintResizeWidth.trace_add('write', outputPathTraceCallback)
        self.varintResizeHeight = tk.IntVar(value=self.config['Config'].getint('ResizeHeight'))
        self.varintResizeHeight.trace_add('write', outputPathTraceCallback)
        self.varstrModel = tk.StringVar(value=self.config['Config'].get('Model'))
        self.varstrModel.trace_add('write', outputPathTraceCallback)
        self.varintDownsampleIndex = tk.IntVar(value=self.config['Config'].getint('DownsampleIndex'))
        self.varintTileSizeIndex = tk.IntVar(value=self.config['Config'].getint('TileSizeIndex'))
        self.varintGPUID = tk.IntVar(value=self.config['Config'].getint('GPUID'))
        self.varboolUseTTA = tk.BooleanVar(value=self.config['Config'].getboolean('UseTTA'))
        self.varboolUseWebP = tk.BooleanVar(value=self.config['Config'].getboolean('UseWebP'))
        self.varboolOptimizeGIF = tk.BooleanVar(value=self.config['Config'].getboolean('OptimizeGIF'))
        self.varboolLossyMode = tk.BooleanVar(value=self.config['Config'].getboolean('LossyMode'))
        self.varintLossyQuality = tk.IntVar(value=self.config['Config'].getint('LossyQuality'))

    def setupWidgets(self):
        self.rowconfigure(0, weight=0)
        self.rowconfigure(1, weight=1)
        self.columnconfigure(0, weight=1)

        self.notebookConfig = ttk.Notebook(self)
        self.notebookConfig.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)

        self.frameBasicConfig = ttk.Frame(self.notebookConfig, padding=5)
        self.frameBasicConfig.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        ttk.Label(self.frameBasicConfig, text=i18n.getTranslatedString('Input')).pack(padx=10, pady=5, fill=tk.X)
        self.frameInputPath = ttk.Frame(self.frameBasicConfig)
        self.frameInputPath.columnconfigure(0, weight=1)
        self.frameInputPath.columnconfigure(1, weight=0)
        self.frameInputPath.pack(padx=5, pady=5, fill=tk.X)
        self.entryInputPath = ttk.Entry(self.frameInputPath, textvariable=self.varstrInputPath)
        self.entryInputPath.grid(row=0, column=0, padx=5, sticky=tk.EW)
        self.buttonInputPath = ttk.Button(self.frameInputPath, text=i18n.getTranslatedString('OpenFileDialog'), command=self.buttonInputPath_click)
        self.buttonInputPath.grid(row=0, column=1, padx=5)
        ttk.Label(self.frameBasicConfig, text=i18n.getTranslatedString('Output')).pack(padx=10, pady=5, fill=tk.X)
        self.frameOutputPath = ttk.Frame(self.frameBasicConfig)
        self.frameOutputPath.columnconfigure(0, weight=1)
        self.frameOutputPath.columnconfigure(1, weight=0)
        self.frameOutputPath.pack(padx=5, pady=5, fill=tk.X)
        self.entryOutputPath = ttk.Entry(self.frameOutputPath, textvariable=self.varstrOutputPath)
        self.entryOutputPath.grid(row=0, column=0, padx=5, sticky=tk.EW)
        self.buttonOutputPath = ttk.Button(self.frameOutputPath, text=i18n.getTranslatedString('OpenFileDialog'), command=self.buttonOutputPath_click)
        self.buttonOutputPath.grid(row=0, column=1, padx=5)
        self.frameBasicConfigBottom = ttk.Frame(self.frameBasicConfig)
        self.frameBasicConfigBottom.columnconfigure(0, weight=0)
        self.frameBasicConfigBottom.columnconfigure(1, weight=1)
        self.frameBasicConfigBottom.pack(fill=tk.X)
        self.frameModel = ttk.Frame(self.frameBasicConfigBottom)
        self.frameModel.grid(row=0, column=1, sticky=tk.NSEW)
        ttk.Label(self.frameModel, text=i18n.getTranslatedString('UsedModel')).pack(padx=10, pady=5, fill=tk.X)
        self.comboModel = ttk.Combobox(self.frameModel, state='readonly', values=self.models, textvariable=self.varstrModel)
        self.comboModel.current(self.models.index(self.varstrModel.get()))
        self.comboModel.pack(padx=10, pady=5, fill=tk.X)
        self.comboModel.bind('<<ComboboxSelected>>', lambda e: e.widget.select_clear())
        self.frameResize = ttk.Frame(self.frameBasicConfigBottom)
        self.frameResize.grid(row=0, column=0, sticky=tk.NSEW)
        ttk.Label(self.frameResize, text=i18n.getTranslatedString('ResizeMode')).grid(row=0, column=0, columnspan=2, padx=10, pady=5, sticky=tk.EW)
        self.radioResizeRatio = ttk.Radiobutton(self.frameResize, text=i18n.getTranslatedString('ResizeModeRatio'), value=int(param.ResizeMode.RATIO), variable=self.varintResizeMode)
        self.radioResizeRatio.grid(row=1, column=0, padx=5, pady=5, sticky=tk.EW)
        self.spinResizeRatio = ttk.Spinbox(self.frameResize, from_=2, to=16, increment=1, width=12, textvariable=self.varintResizeRatio)
        self.spinResizeRatio.grid(row=1, column=1, padx=5, pady=5, sticky=tk.EW)
        self.radioResizeWidth = ttk.Radiobutton(self.frameResize, text=i18n.getTranslatedString('ResizeModeWidth'), value=int(param.ResizeMode.WIDTH), variable=self.varintResizeMode)
        self.radioResizeWidth.grid(row=2, column=0, padx=5, pady=5, sticky=tk.EW)
        self.spinResizeWidth = ttk.Spinbox(self.frameResize, from_=1, to=16383, increment=1, width=12, textvariable=self.varintResizeWidth)
        self.spinResizeWidth.grid(row=2, column=1, padx=5, pady=5, sticky=tk.EW)
        self.radioResizeHeight = ttk.Radiobutton(self.frameResize, text=i18n.getTranslatedString('ResizeModeHeight'), value=int(param.ResizeMode.HEIGHT), variable=self.varintResizeMode)
        self.radioResizeHeight.grid(row=3, column=0, padx=5, pady=5, sticky=tk.EW)
        self.spinResizeHeight = ttk.Spinbox(self.frameResize, from_=1, to=16383, increment=1, width=12, textvariable=self.varintResizeHeight)
        self.spinResizeHeight.grid(row=3, column=1, padx=5, pady=5, sticky=tk.EW)
        self.buttonProcess = ttk.Button(self.frameBasicConfigBottom, text=i18n.getTranslatedString('StartProcessing'), style='Accent.TButton', width=6, command=self.buttonProcess_click)
        self.buttonProcess.grid(row=0, column=1, padx=5, pady=5, sticky=tk.SE)

        self.frameAdvancedConfig = ttk.Frame(self.notebookConfig, padding=5)
        self.frameAdvancedConfig.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        self.frameAdvancedConfig.columnconfigure(0, weight=1)
        self.frameAdvancedConfig.columnconfigure(1, weight=1)
        self.frameAdvancedConfigLeft = ttk.Frame(self.frameAdvancedConfig)
        self.frameAdvancedConfigLeft.grid(row=0, column=0, sticky=tk.NSEW)
        self.frameAdvancedConfigRight = ttk.Frame(self.frameAdvancedConfig)
        self.frameAdvancedConfigRight.grid(row=0, column=1, sticky=tk.NSEW)
        ttk.Label(self.frameAdvancedConfigLeft, text=i18n.getTranslatedString('DownsampleMode')).pack(padx=10, pady=5, fill=tk.X)
        self.comboDownsample = ttk.Combobox(self.frameAdvancedConfigLeft, state='readonly', values=tuple(x[0] for x in self.downsample))
        self.comboDownsample.current(self.varintDownsampleIndex.get())
        self.comboDownsample.pack(padx=10, pady=5, fill=tk.X)
        self.comboDownsample.bind('<<ComboboxSelected>>', self.comboDownsample_click)
        ttk.Label(self.frameAdvancedConfigLeft, text=i18n.getTranslatedString('UsedGPUID')).pack(padx=10, pady=5, fill=tk.X)
        self.spinGPUID = ttk.Spinbox(self.frameAdvancedConfigLeft, from_=0, to=7, increment=1, width=12, textvariable=self.varintGPUID)
        self.spinGPUID.set(0)
        self.spinGPUID.pack(padx=10, pady=5, fill=tk.X)
        ttk.Label(self.frameAdvancedConfigLeft, text=i18n.getTranslatedString('TileSize')).pack(padx=10, pady=5, fill=tk.X)
        self.comboTileSize = ttk.Combobox(self.frameAdvancedConfigLeft, state='readonly', values=(i18n.getTranslatedString('TileSizeAuto'), *self.tileSize[1:]))
        self.comboTileSize.current(self.varintTileSizeIndex.get())
        self.comboTileSize.pack(padx=10, pady=5, fill=tk.X)
        ttk.Label(self.frameAdvancedConfigLeft, text=i18n.getTranslatedString('LossyModeQuality')).pack(padx=10, pady=5, fill=tk.X)
        self.spinLossyQuality = ttk.Spinbox(self.frameAdvancedConfigLeft, from_=0, to=100, increment=5, width=12, textvariable=self.varintLossyQuality)
        self.spinLossyQuality.set(self.varintLossyQuality.get())
        self.spinLossyQuality.pack(padx=10, pady=5, fill=tk.X)
        self.comboTileSize.bind('<<ComboboxSelected>>', self.comboTileSize_click)
        self.checkUseWebP = ttk.Checkbutton(self.frameAdvancedConfigRight, text=i18n.getTranslatedString('PreferWebP'), style='Switch.TCheckbutton', variable=self.varboolUseWebP)
        self.checkUseWebP.pack(padx=10, pady=5, fill=tk.X)
        self.checkUseTTA = ttk.Checkbutton(self.frameAdvancedConfigRight, text=i18n.getTranslatedString('EnableTTA'), style='Switch.TCheckbutton', variable=self.varboolUseTTA)
        self.checkUseTTA.pack(padx=10, pady=5, fill=tk.X)
        self.checkOptimizeGIF = ttk.Checkbutton(self.frameAdvancedConfigRight, text=i18n.getTranslatedString('GIFOptimizeTransparency'), style='Switch.TCheckbutton', variable=self.varboolOptimizeGIF)
        self.checkOptimizeGIF.pack(padx=10, pady=5, fill=tk.X)
        self.checkLossyMode = ttk.Checkbutton(self.frameAdvancedConfigRight, text=i18n.getTranslatedString('EnableLossyMode'), style='Switch.TCheckbutton', variable=self.varboolLossyMode)
        self.checkLossyMode.pack(padx=10, pady=5, fill=tk.X)

        self.frameAbout = ttk.Frame(self.notebookConfig, padding=5)
        self.frameAbout.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        self.frameAboutContent = ttk.Frame(self.frameAbout)
        self.frameAboutContent.place(relx=.5, rely=.5, anchor=tk.CENTER)
        f = ttk.Label().cget('font').string.split(' ')
        f[-1] = '16'
        f = ' '.join(f)
        self.imageIcon = ImageTk.PhotoImage(Image.open(os.path.join(define.BASE_PATH, 'icon-128px.png')))
        ttk.Label(self.frameAboutContent, image=self.imageIcon).pack(padx=10, pady=10)
        ttk.Label(self.frameAboutContent, text=define.APP_TITLE, font=f, justify=tk.CENTER).pack()
        ttk.Label(self.frameAboutContent, text='By TransparentLC' + (time.strftime("\nBuilt at %Y-%m-%d %H:%M:%S", time.localtime(define.BUILD_TIME)) if define.BUILD_TIME else ""), justify=tk.CENTER).pack()
        self.frameAboutBottom = ttk.Frame(self.frameAboutContent)
        self.frameAboutBottom.pack()
        ttk.Button(self.frameAboutBottom, text=i18n.getTranslatedString('ViewREGUISource'), command=lambda: webbrowser.open_new_tab('https://github.com/TransparentLC/realesrgan-gui')).grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        ttk.Button(self.frameAboutBottom, text=i18n.getTranslatedString('ViewRESource'), command=lambda: webbrowser.open_new_tab('https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan')).grid(row=0, column=1, padx=5, pady=5, sticky=tk.NSEW)
        ttk.Button(self.frameAboutBottom, text=i18n.getTranslatedString('ViewDonatePage'), command=lambda: webbrowser.open_new_tab('https://i.akarin.dev/donate/')).grid(row=0, column=2, padx=5, pady=5, sticky=tk.NSEW)

        self.notebookConfig.add(self.frameBasicConfig, text=i18n.getTranslatedString('FrameBasicConfig'))
        self.notebookConfig.add(self.frameAdvancedConfig, text=i18n.getTranslatedString('FrameAdvancedConfig'))
        self.notebookConfig.add(self.frameAbout, text=i18n.getTranslatedString('FrameAbout'))

        self.textOutput = ScrolledText(self)
        self.textOutput.grid(row=1, column=0, padx=5, pady=5, sticky=tk.NSEW)
        self.textOutput.configure(state=tk.DISABLED)

    def close(self):
        self.config['DEFAULT'] = {}
        self.config['Config'] = {
            'ResizeMode': self.varintResizeMode.get(),
            'ResizeRatio': self.varintResizeRatio.get(),
            'ResizeWidth': self.varintResizeWidth.get(),
            'ResizeHeight': self.varintResizeHeight.get(),
            'Model': self.varstrModel.get(),
            'DownsampleIndex': self.varintDownsampleIndex.get(),
            'GPUID': self.varintGPUID.get(),
            'TileSizeIndex': self.varintTileSizeIndex.get(),
            'LossyQuality': self.varintLossyQuality.get(),
            'UseWebP': self.varboolUseWebP.get(),
            'UseTTA': self.varboolUseTTA.get(),
            'OptimizeGIF': self.varboolOptimizeGIF.get(),
            'LossyMode': self.varboolLossyMode.get(),
        }
        with open(define.APP_CONFIG_PATH, 'w', encoding='utf-8') as f:
            self.config.write(f)

    def buttonInputPath_click(self):
        p = filedialog.askopenfilename(filetypes=(
            ('Image files', ('.jpg', '.jpeg', '.png', '.gif', '.webp')),
        ))
        if not p:
            return
        self.setInputPath(p)

    def buttonOutputPath_click(self):
        p = filedialog.askopenfilename(filetypes=(
            ('Image files', ('.png', '.gif', '.webp')),
        ))
        if not p:
            return
        self.varstrOutputPath.set(p)

    def comboDownsample_click(self, event: tk.Event):
        self.comboDownsample.select_clear()
        self.varintDownsampleIndex.set(self.comboDownsample.current())

    def comboTileSize_click(self, event: tk.Event):
        self.comboTileSize.select_clear()
        self.varintTileSizeIndex.set(self.comboTileSize.current())

    def buttonProcess_click(self):
        inputPath = self.varstrInputPath.get()
        outputPath = self.varstrOutputPath.get()
        if not inputPath or not outputPath:
            return messagebox.showwarning(define.APP_TITLE, i18n.getTranslatedString('WarningInvalidPath'))
        inputPath = os.path.normpath(inputPath)
        outputPath = os.path.normpath(outputPath)
        if not os.path.exists(inputPath):
            return messagebox.showwarning(define.APP_TITLE, i18n.getTranslatedString('WarningNotFoundPath'))

        initialConfigParams = self.getConfigParams()
        if initialConfigParams.resizeMode == param.ResizeMode.RATIO and initialConfigParams.resizeModeValue == 1:
            return messagebox.showwarning(define.APP_TITLE, i18n.getTranslatedString('WarningResizeRatio'))

        queue = collections.deque()
        if os.path.isdir(inputPath):
            for curDir, dirs, files in os.walk(inputPath):
                for f in files:
                    if os.path.splitext(f)[1].lower() not in {'.jpg', '.jpeg', '.png', '.gif', '.webp'}:
                        continue
                    f = os.path.join(curDir, f)
                    g = os.path.join(outputPath, f.removeprefix(inputPath + os.path.sep))
                    if os.path.splitext(f)[1].lower() == '.gif':
                        queue.append(task.SplitGIFTask(self.writeToOutput, f, g, initialConfigParams, queue, self.varboolOptimizeGIF.get()))
                    elif self.varboolLossyMode.get() and os.path.splitext(g)[1].lower() in {'.jpg', '.jpeg', '.webp'}:
                        t = task.buildTempPath('.webp')
                        queue.append(task.RESpawnTask(self.writeToOutput, f, t, initialConfigParams))
                        queue.append(task.LossyCompressTask(self.writeToOutput, t, g, self.varintLossyQuality.get(), True))
                    else:
                        queue.append(task.RESpawnTask(self.writeToOutput, f, g, initialConfigParams))
            if not queue:
                return messagebox.showwarning(define.APP_TITLE, i18n.getTranslatedString('WarningEmptyFolder'))
        elif os.path.splitext(inputPath)[1].lower() in {'.jpg', '.jpeg', '.png', '.gif', '.webp'}:
            if os.path.splitext(inputPath)[1].lower() == '.gif':
                queue.append(task.SplitGIFTask(self.writeToOutput, inputPath, outputPath, initialConfigParams, queue, self.varboolOptimizeGIF.get()))
            elif self.varboolLossyMode.get() and os.path.splitext(outputPath)[1].lower() in {'.jpg', '.jpeg', '.webp'}:
                t = task.buildTempPath('.webp')
                queue.append(task.RESpawnTask(self.writeToOutput, inputPath, t, initialConfigParams))
                queue.append(task.LossyCompressTask(self.writeToOutput, t, outputPath, self.varintLossyQuality.get(), True))
            else:
                queue.append(task.RESpawnTask(self.writeToOutput, inputPath, outputPath, initialConfigParams))
        else:
            return messagebox.showwarning(define.APP_TITLE, i18n.getTranslatedString('WarningInvalidFormat'))
        self.buttonProcess.config(state=tk.DISABLED)
        self.textOutput.config(state=tk.NORMAL)
        self.textOutput.delete(1.0, tk.END)
        self.textOutput.config(state=tk.DISABLED)
        notification = notifypy.Notify(
            default_notification_application_name=define.APP_TITLE,
            default_notification_icon=os.path.join(define.BASE_PATH, 'icon-128px.png'),
        )
        ts = time.perf_counter()
        def completeCallback():
            te = time.perf_counter()
            self.buttonProcess.config(state=tk.NORMAL)
            notification.title = i18n.getTranslatedString('ToastCompletedTitle')
            notification.message = i18n.getTranslatedString('ToastCompletedMessage').format(outputPath, (te - ts) / 1000)
            notification.send(False)
        def failCallback(ex: Exception):
            self.buttonProcess.config(state=tk.NORMAL)
            notification.title = i18n.getTranslatedString('ToastFailedTitle')
            notification.message = f'{type(ex).__name__}: {ex}'
            notification.send(False)
        t = threading.Thread(
            target=task.taskRunner,
            args=(
                queue,
                self.writeToOutput,
                completeCallback,
                failCallback,
            )
        )
        t.start()

    def setInputPath(self, p: str):
        self.varstrInputPath.set(p)
        self.varstrOutputPath.set(self.getOutputPath(p))
        self.outputPathChanged = False

    def writeToOutput(self, s: str):
        self.textOutput.config(state=tk.NORMAL)
        self.textOutput.insert(tk.END, s)
        self.textOutput.config(state=tk.DISABLED)
        yview = self.textOutput.yview()
        if yview[1] - yview[0] > .5 or yview[1] > .9:
            self.textOutput.see('end')

    def getConfigParams(self) -> param.REConfigParams:
        resizeModeValue = 0
        match self.varintResizeMode.get():
            case param.ResizeMode.RATIO:
                resizeModeValue = self.varintResizeRatio.get()
            case param.ResizeMode.WIDTH:
                resizeModeValue = self.varintResizeWidth.get()
            case param.ResizeMode.HEIGHT:
                resizeModeValue = self.varintResizeHeight.get()
        return param.REConfigParams(
            self.varstrModel.get(),
            self.modelFactors[self.varstrModel.get()],
            self.varintResizeMode.get(),
            resizeModeValue,
            self.downsample[self.varintDownsampleIndex.get()][1],
            self.tileSize[self.varintTileSizeIndex.get()],
            self.varintGPUID.get(),
            self.varboolUseTTA.get(),
        )

    def getOutputPath(self, p: str) -> str:
        if os.path.isdir(p):
            base, ext = p, ''
        else:
            base, ext = os.path.splitext(p)
            if ext.lower() == '.jpg':
                ext = '.png'
            if ext.lower() == '.png' and self.varboolUseWebP.get():
                ext = '.webp'
        suffix = ''
        match self.varintResizeMode.get():
            case param.ResizeMode.RATIO:
                suffix = f'x{self.varintResizeRatio.get()}'
            case param.ResizeMode.WIDTH:
                suffix = f'w{self.varintResizeWidth.get()}'
            case param.ResizeMode.HEIGHT:
                suffix = f'h{self.varintResizeHeight.get()}'
        return f'{base} ({self.models[self.comboModel.current()]} {suffix}){ext}'

if __name__ == '__main__':
    os.chdir(define.APP_PATH)
    root = TkinterDnD.Tk(className=define.APP_TITLE)
    root.withdraw()

    if not os.path.exists(define.RE_PATH):
        messagebox.showwarning(define.APP_TITLE, i18n.getTranslatedString('WarningNotFoundRE'))
        webbrowser.open_new_tab('https://github.com/xinntao/Real-ESRGAN/releases')
        sys.exit(0)

    root.title(define.APP_TITLE)
    try:
        root.iconbitmap(os.path.join(define.BASE_PATH, 'icon-256px.ico'))
    except tk.TclError:
        root.tk.call('wm', 'iconphoto', root._w, ImageTk.PhotoImage(Image.open(os.path.join(define.BASE_PATH, 'icon-256px.ico'))))

    root.tk.call('source', os.path.join(define.BASE_PATH, 'theme', 'sun-valley.tcl'))
    try:
        import darkdetect
        root.tk.call('set_theme', 'dark' if darkdetect.isDark() else 'light')
        if sys.platform in {'win32', 'linux'}:
            t = threading.Thread(target=darkdetect.listener, args=(lambda e: root.tk.call('set_theme', e.lower()),))
            t.daemon = True
            t.start()
    except:
        print(traceback.format_exc())
        root.tk.call('set_theme', 'light')

    app = REGUIApp(root)
    app.drop_target_register(DND_FILES)
    app.dnd_bind(
        '<<Drop>>',
        lambda e: app.setInputPath(e.data[1:-1] if '{' == e.data[0] and '}' == e.data[-1] else e.data),
    )
    app.pack(fill=tk.BOTH, expand=True)
    root.protocol('WM_DELETE_WINDOW', lambda: (
        app.close(),
        root.destroy(),
    ))

    initialSize = (720, 540)
    root.minsize(*initialSize)
    root.geometry('{}x{}+{}+{}'.format(
        *initialSize,
        (root.winfo_screenwidth() - initialSize[0]) // 2,
        (root.winfo_screenheight() - initialSize[1]) // 2,
    ))

    root.deiconify()
    root.mainloop()