import collections
import darkdetect
import os
import sys
import time
import threading
import tkinter as tk
import webbrowser
from PIL import Image
from PIL import ImageTk
from tkinter import filedialog
from tkinter import messagebox
from tkinter import ttk
from tkinter.scrolledtext import ScrolledText
from tkinterdnd2 import DND_FILES
from tkinterdnd2 import TkinterDnD

import param
import task

BASE_PATH = sys._MEIPASS if hasattr(sys, '_MEIPASS') else ''
APP_PATH = os.path.dirname(os.path.realpath(sys.executable if hasattr(sys, '_MEIPASS') else __file__))
from build_time import BUILD_TIME

class REGUIApp(ttk.Frame):
    def __init__(self, parent: tk.Tk):
        super().__init__(parent)
        modelFiles = set(os.listdir(os.path.join(APP_PATH, 'models')))
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
        self.setupVars()
        self.setupWidgets()

    def setupVars(self):
        self.varstrInputPath = tk.StringVar()
        self.varstrOutputPath = tk.StringVar()
        self.varintResizeMode = tk.IntVar(value=int(param.ResizeMode.RATIO))
        self.varintResizeRatio = tk.IntVar(value=4)
        self.varintResizeWidth = tk.IntVar()
        self.varintResizeHeight = tk.IntVar()
        self.varstrModel = tk.StringVar()
        self.varintDownsampleIndex = tk.IntVar()
        self.varintTileSizeIndex = tk.IntVar()
        self.varintGPUID = tk.IntVar()
        self.varboolUseTTA = tk.BooleanVar()
        self.varboolUseWebP = tk.BooleanVar()

    def setupWidgets(self):
        self.rowconfigure(0, weight=0)
        self.rowconfigure(1, weight=1)
        self.columnconfigure(0, weight=1)

        self.notebookConfig = ttk.Notebook(self)
        self.notebookConfig.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)

        self.frameBasicConfig = ttk.Frame(self.notebookConfig, padding=5)
        self.frameBasicConfig.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        ttk.Label(self.frameBasicConfig, text='输入（文件或文件夹）').pack(padx=10, pady=5, fill=tk.X)
        self.frameInputPath = ttk.Frame(self.frameBasicConfig)
        self.frameInputPath.columnconfigure(0, weight=1)
        self.frameInputPath.columnconfigure(1, weight=0)
        self.frameInputPath.pack(padx=5, pady=5, fill=tk.X)
        self.entryInputPath = ttk.Entry(self.frameInputPath, textvariable=self.varstrInputPath)
        self.entryInputPath.grid(row=0, column=0, padx=5, sticky=tk.EW)
        self.buttonInputPath = ttk.Button(self.frameInputPath, text='浏览', command=self.buttonInputPath_click)
        self.buttonInputPath.grid(row=0, column=1, padx=5)
        ttk.Label(self.frameBasicConfig, text='输出').pack(padx=10, pady=5, fill=tk.X)
        self.frameOutputPath = ttk.Frame(self.frameBasicConfig)
        self.frameOutputPath.columnconfigure(0, weight=1)
        self.frameOutputPath.columnconfigure(1, weight=0)
        self.frameOutputPath.pack(padx=5, pady=5, fill=tk.X)
        self.entryOutputPath = ttk.Entry(self.frameOutputPath, textvariable=self.varstrOutputPath)
        self.entryOutputPath.grid(row=0, column=0, padx=5, sticky=tk.EW)
        self.buttonOutputPath = ttk.Button(self.frameOutputPath, text='浏览', command=self.buttonOutputPath_click)
        self.buttonOutputPath.grid(row=0, column=1, padx=5)
        self.frameBasicConfigBottom = ttk.Frame(self.frameBasicConfig)
        self.frameBasicConfigBottom.columnconfigure(0, weight=0)
        self.frameBasicConfigBottom.columnconfigure(1, weight=1)
        self.frameBasicConfigBottom.pack(fill=tk.X)
        self.frameModel = ttk.Frame(self.frameBasicConfigBottom)
        self.frameModel.grid(row=0, column=1, sticky=tk.NSEW)
        ttk.Label(self.frameModel, text='模型').pack(padx=10, pady=5, fill=tk.X)
        self.comboModel = ttk.Combobox(self.frameModel, state='readonly', values=self.models, textvariable=self.varstrModel)
        self.comboModel.current(0)
        self.comboModel.pack(padx=10, pady=5, fill=tk.X)
        self.comboModel.bind('<<ComboboxSelected>>', lambda e: e.widget.select_clear())
        self.frameResize = ttk.Frame(self.frameBasicConfigBottom)
        self.frameResize.grid(row=0, column=0, sticky=tk.NSEW)
        ttk.Label(self.frameResize, text='放大尺寸计算方式').grid(row=0, column=0, columnspan=2, padx=10, pady=5, sticky=tk.EW)
        self.radioResizeRatio = ttk.Radiobutton(self.frameResize, text='固定倍率', value=int(param.ResizeMode.RATIO), variable=self.varintResizeMode)
        self.radioResizeRatio.grid(row=1, column=0, padx=5, pady=5, sticky=tk.EW)
        self.spinResizeRatio = ttk.Spinbox(self.frameResize, from_=2, to=16, increment=1, width=12, textvariable=self.varintResizeRatio)
        self.spinResizeRatio.grid(row=1, column=1, padx=5, pady=5, sticky=tk.EW)
        self.radioResizeWidth = ttk.Radiobutton(self.frameResize, text='等比放大到宽度', value=int(param.ResizeMode.WIDTH), variable=self.varintResizeMode)
        self.radioResizeWidth.grid(row=2, column=0, padx=5, pady=5, sticky=tk.EW)
        self.spinResizeWidth = ttk.Spinbox(self.frameResize, from_=1, to=16383, increment=1, width=12, textvariable=self.varintResizeWidth)
        self.spinResizeWidth.grid(row=2, column=1, padx=5, pady=5, sticky=tk.EW)
        self.radioResizeHeight = ttk.Radiobutton(self.frameResize, text='等比放大到高度', value=int(param.ResizeMode.HEIGHT), variable=self.varintResizeMode)
        self.radioResizeHeight.grid(row=3, column=0, padx=5, pady=5, sticky=tk.EW)
        self.spinResizeHeight = ttk.Spinbox(self.frameResize, from_=1, to=16383, increment=1, width=12, textvariable=self.varintResizeHeight)
        self.spinResizeHeight.grid(row=3, column=1, padx=5, pady=5, sticky=tk.EW)
        self.buttonProcess = ttk.Button(self.frameBasicConfigBottom, text='开始', style='Accent.TButton', width=6, command=self.buttonProcess_click)
        self.buttonProcess.grid(row=0, column=1, padx=5, pady=5, sticky=tk.SE)

        self.frameAdvancedConfig = ttk.Frame(self.notebookConfig, padding=5)
        self.frameAdvancedConfig.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        self.frameAdvancedConfig.columnconfigure(0, weight=1)
        self.frameAdvancedConfig.columnconfigure(1, weight=1)
        self.frameAdvancedConfigLeft = ttk.Frame(self.frameAdvancedConfig)
        self.frameAdvancedConfigLeft.grid(row=0, column=0, sticky=tk.NSEW)
        self.frameAdvancedConfigRight = ttk.Frame(self.frameAdvancedConfig)
        self.frameAdvancedConfigRight.grid(row=0, column=1, sticky=tk.NSEW)
        ttk.Label(self.frameAdvancedConfigLeft, text='降采样方式').pack(padx=10, pady=5, fill=tk.X)
        self.comboDownsample = ttk.Combobox(self.frameAdvancedConfigLeft, state='readonly', values=tuple(x[0] for x in self.downsample))
        self.comboDownsample.current(0)
        self.comboDownsample.pack(padx=10, pady=5, fill=tk.X)
        self.comboDownsample.bind('<<ComboboxSelected>>', self.comboDownsample_click)
        ttk.Label(self.frameAdvancedConfigLeft, text='使用的 GPU ID').pack(padx=10, pady=5, fill=tk.X)
        self.spinGPUID = ttk.Spinbox(self.frameAdvancedConfigLeft, from_=0, to=7, increment=1, width=12, textvariable=self.varintGPUID)
        self.spinGPUID.set(0)
        self.spinGPUID.pack(padx=10, pady=5, fill=tk.X)
        ttk.Label(self.frameAdvancedConfigLeft, text='拆分大小').pack(padx=10, pady=5, fill=tk.X)
        self.comboTileSize = ttk.Combobox(self.frameAdvancedConfigLeft, state='readonly', values=('自动决定', *self.tileSize[1:]))
        self.comboTileSize.current(0)
        self.comboTileSize.pack(padx=10, pady=5, fill=tk.X)
        self.comboTileSize.bind('<<ComboboxSelected>>', self.comboTileSize_click)
        self.checkUseWebP = ttk.Checkbutton(self.frameAdvancedConfigRight, text='优先保存为无损 WebP', style='Switch.TCheckbutton', variable=self.varboolUseWebP)
        self.checkUseWebP.pack(padx=10, pady=5, fill=tk.X)
        self.checkUseTTA = ttk.Checkbutton(self.frameAdvancedConfigRight, text='使用 TTA 模式（速度大幅下降，稍微提高质量）', style='Switch.TCheckbutton', variable=self.varboolUseTTA)
        self.checkUseTTA.pack(padx=10, pady=5, fill=tk.X)

        self.frameAbout = ttk.Frame(self.notebookConfig, padding=5)
        self.frameAbout.grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        self.frameAboutContent = ttk.Frame(self.frameAbout)
        self.frameAboutContent.place(relx=.5, rely=.5, anchor=tk.CENTER)
        f = ttk.Label().cget('font').string.split(' ')
        f[-1] = '16'
        f = ' '.join(f)
        self.imageIcon = ImageTk.PhotoImage(Image.open(os.path.join(BASE_PATH, 'icon-128px.webp')))
        ttk.Label(self.frameAboutContent, image=self.imageIcon).pack(padx=10, pady=10)
        ttk.Label(self.frameAboutContent, text='Real-ESRGAN GUI', font=f, justify=tk.CENTER).pack()
        ttk.Label(self.frameAboutContent, text='By TransparentLC' + (time.strftime("\nBuilt at %Y-%m-%d %H:%M:%S", time.localtime(BUILD_TIME)) if BUILD_TIME else ""), justify=tk.CENTER).pack()
        self.frameAboutBottom = ttk.Frame(self.frameAboutContent)
        self.frameAboutBottom.pack()
        ttk.Button(self.frameAboutBottom, text='查看源代码', command=lambda: webbrowser.open_new_tab('https://github.com/TransparentLC/realesrgan-gui')).grid(row=0, column=0, padx=5, pady=5, sticky=tk.NSEW)
        ttk.Button(self.frameAboutBottom, text='查看 Real-ESRGAN 介绍', command=lambda: webbrowser.open_new_tab('https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan')).grid(row=0, column=1, padx=5, pady=5, sticky=tk.NSEW)

        self.notebookConfig.add(self.frameBasicConfig, text='基本设定')
        self.notebookConfig.add(self.frameAdvancedConfig, text='高级设定')
        self.notebookConfig.add(self.frameAbout, text='关于')

        self.textOutput = ScrolledText(self)
        self.textOutput.grid(row=1, column=0, padx=5, pady=5, sticky=tk.NSEW)
        self.textOutput.configure(state=tk.DISABLED)

    def buttonInputPath_click(self):
        p = filedialog.askopenfilename(filetypes=(
            ('Image files', ('.jpg', '.png', '.gif', '.webp')),
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
            return messagebox.showwarning(None, '请输入有效的输入和输出路径。')
        inputPath = os.path.normpath(inputPath)
        outputPath = os.path.normpath(outputPath)
        if not os.path.exists(inputPath):
            return messagebox.showwarning(None, '输入的文件或目录不存在。')

        initialConfigParams = self.getConfigParams()
        queue = collections.deque()
        if os.path.isdir(inputPath):
            for curDir, dirs, files in os.walk(inputPath):
                for f in files:
                    if os.path.splitext(f)[1].lower() not in {'.jpg', '.jpeg', '.png', '.gif', '.webp'}:
                        continue
                    f = os.path.join(curDir, f)
                    g = os.path.join(outputPath, f.removeprefix(inputPath + os.path.sep))
                    queue.append((
                        task.SplitGIFTask(self.writeToOutput, f, g, initialConfigParams, queue)
                        if os.path.splitext(f)[1].lower() == '.gif' else
                        task.RESpawnTask(self.writeToOutput, f, g, initialConfigParams)
                    ))
            if not queue:
                return messagebox.showwarning('批量处理提示', '文件夹内没有可以处理的图片文件。')
        elif os.path.splitext(inputPath)[1].lower() in {'.jpg', '.jpeg', '.png', '.gif', '.webp'}:
            queue.append((
                task.SplitGIFTask(self.writeToOutput, inputPath, outputPath, initialConfigParams, queue)
                if os.path.splitext(inputPath)[1].lower() == '.gif' else
                task.RESpawnTask(self.writeToOutput, inputPath, outputPath, initialConfigParams)
            ))
        else:
            return messagebox.showwarning('格式错误', '仅支持 JPEG、PNG、GIF 和 WebP 格式的图片文件。')
        self.buttonProcess.config(state=tk.DISABLED)
        self.textOutput.config(state=tk.NORMAL)
        self.textOutput.delete(1.0, tk.END)
        self.textOutput.config(state=tk.DISABLED)
        t = threading.Thread(
            target=task.taskRunner,
            args=(
                queue,
                self.writeToOutput,
                lambda: self.buttonProcess.config(state=tk.NORMAL),
            )
        )
        t.start()

    def setInputPath(self, p: str):
        self.varstrInputPath.set(p)
        self.varstrOutputPath.set(self.getOutputPath(p))

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
        return f'{base}-{suffix}{ext}'

if __name__ == '__main__':
    root = TkinterDnD.Tk()
    root.withdraw()

    if not os.path.exists(os.path.join(APP_PATH, 'realesrgan-ncnn-vulkan' + ('.exe' if os.name == 'nt' else ''))):
        messagebox.showwarning(
            '未找到主程序',
            '未找到 Real-ESRGAN-ncnn-vulkan 主程序。\n请前往 https://github.com/xinntao/Real-ESRGAN/releases 下载，并将本文件和主程序放在同一目录下。',
        )
        webbrowser.open_new_tab('https://github.com/xinntao/Real-ESRGAN/releases')
        sys.exit(0)

    root.title('Real-ESRGAN GUI')
    try:
        root.iconbitmap(os.path.join(BASE_PATH, 'icon-256px.ico'))
    except tk.TclError:
        root.tk.call('wm', 'iconphoto', root._w, ImageTk.PhotoImage(Image.open(os.path.join(BASE_PATH, 'icon-256px.ico'))))

    root.tk.call('source', os.path.join(BASE_PATH, 'theme/sun-valley.tcl'))
    root.tk.call('set_theme', 'dark' if darkdetect.isDark() else 'light')

    app = REGUIApp(root)
    app.drop_target_register(DND_FILES)
    app.dnd_bind(
        '<<Drop>>',
        lambda e: app.setInputPath(e.data[1:-1] if '{' == e.data[0] and '}' == e.data[-1] else e.data),
    )
    app.pack(fill=tk.BOTH, expand=True)

    initialSize = (720, 540)
    root.minsize(*initialSize)
    root.geometry('{}x{}+{}+{}'.format(
        *initialSize,
        (root.winfo_screenwidth() - initialSize[0]) // 2,
        (root.winfo_screenheight() - initialSize[1]) // 2,
    ))

    root.deiconify()
    root.mainloop()