# Real-ESRGAN GUI

[![build](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml/badge.svg)](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml)

实用、美观的图片放大工具 Real-ESRGAN 的图形界面，参考 [waifu2x-caffe](https://github.com/lltcggie/waifu2x-caffe) 设计。

![](https://user-images.githubusercontent.com/47057319/166252452-d3e7dfbd-2e91-4aaa-95bd-0937adb3d00b.png)

## 基本介绍

这个程序是 Real-ESRGAN 的命令行程序 [Real-ESRGAN-ncnn-vulkan](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan) 的图形界面，使用 Python 和 tkinter 编写。

使用时请将这里的所有文件或打包后的可执行文件和 Real-ESRGAN-ncnn-vulkan 的可执行文件放在同一个目录。从源代码运行前，请使用 `pip install -r requirements.txt` 安装依赖。

> 可以在 [Release](https://github.com/TransparentLC/realesrgan-gui/releases) 下载适用于 Windows 10 和 Ubuntu 20.04（或更新版本系统，其他 Linux 发行版未测试）的打包好的版本。文件名包含 `bundled` 的压缩包整合了 Real-ESRGAN-ncnn-vulkan 的可执行文件和模型，这样就不需要另外下载了。
>
> 也可以在 [Actions](https://nightly.link/TransparentLC/realesrgan-gui/workflows/build/master) 下载根据现有代码打包好的版本（相当于 Nightly）。Actions 打包额外添加了 macOS 版本，但是可用性未经测试。

## 功能介绍

在原版支持的功能的基础上，增加了以下功能：

* 任意尺寸放大
    * Real-ESRGAN 只能将输入的图片以固定的 2-4x 倍率（和选用的模型有关）放大。
    * 这一功能通过多次调用 Real-ESRGAN 后使用常规缩放算法降采样实现。
    * 例如将 640x360 的图片使用 2x 的模型放大到宽度 1600，实际操作为先放大到 1280x720，再放大到 2560x1440，最后降采样到 1600x900。
    * 默认使用 Lanczos 进行降采样，也可以选择其它算法。
* 对 GIF 的处理
    * 将 GIF 的各个帧拆分出来并记录时长，逐个放大后再进行合并。
* 拖拽支持
    * 将图片文件或目录拖拽到窗口的任意位置上，即可自动将它的路径设定为输入和输出路径。
    * 根据拖拽时选择的放大尺寸计算方式，在输出路径中会自动添加形如 x4、w1280、h1080 的后缀。
* 深色模式界面
    * 使用 [darkdetect](https://github.com/albertosottile/darkdetect) 实现。
    * 在启动时根据系统设定选择使用浅色或深色模式界面，在 Windows 上还支持在修改系统设定时自动切换。
* 多语言支持
    * 界面语言和系统语言（使用 `locale.getdefaultlocale` 获取）一致。
    * 目前支持简繁中文和英语。
    * 可以通过 `i18n.ini` 添加和修改翻译。在缺少某个语言的翻译文本的情况下，默认会回退到英语。

## 效果对比

| Nearest Neighbor | Lanczos | waifu2x-caffe | Real-ESRGAN |
| --- | --- | --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/166262181-cf1e6c02-a8d2-4d49-88d9-1dfe65107c18.png) | ![](https://user-images.githubusercontent.com/47057319/166262508-32010b72-76b1-4edb-ba8a-f850283873ea.png) | ![](https://user-images.githubusercontent.com/47057319/166262200-a350b33b-9ebb-4159-889c-38d9d5bba386.png) | ![](https://user-images.githubusercontent.com/47057319/166262192-735fb21b-7452-48fe-b99d-ed8233af6d31.png) |

| Nearest Neighbor | Lanczos | waifu2x-caffe | Real-ESRGAN |
| --- | --- | --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/166262217-7623a30d-e4e9-46e4-a869-1dcabdbbd74e.png) | ![](https://user-images.githubusercontent.com/47057319/166262210-a836ed72-b197-4f5f-bcfd-3e459ebf5776.png) | ![](https://user-images.githubusercontent.com/47057319/166262243-810b894d-657d-4a84-84bb-88e76845404f.png) | ![](https://user-images.githubusercontent.com/47057319/166262229-6bc75e4b-9980-4c14-b4e4-4c0d53642a35.png) |

| Nearest Neighbor | Real-ESRGAN |
| --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/168476063-28a142d4-87ef-491e-b50e-6c981236133f.gif) | ![](https://user-images.githubusercontent.com/47057319/168476067-68e76ed6-9589-44f8-ada8-2792dda0ded4.gif) |

| Nearest Neighbor | Real-ESRGAN |
| --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/170270314-dce674be-e1d3-433f-a71f-763983b33e97.gif) | ![](https://user-images.githubusercontent.com/47057319/170273963-4b11551b-44e7-42f8-b0fd-5b2599087a95.gif) |

* waifu2x-caffe 使用 UpResNet10 和 UpPhoto 模型，降噪等级 3，开启 TTA。
* Real-ESRGAN 使用 realesrgan-x4plus-anime 和 realesrgan-x4plus 模型，开启 TTA。
* 放大倍率均为 4x。
* 为了减小文件大小，展示的 GIF 进行了有损压缩处理。

## 可能遇到的问题

### 如何选择模型

对于三次元图片建议使用 `realesrgan-x4plus`，对于二次元图片建议使用 `realesrgan-x4plus-anime`。

对于同一系列模型的不同倍率版本，建议选择等于或大于想要将图片放大的倍率的版本。例如在想要将图片放大到 3x 但是只有 x2 和 x4 模型的情况下，应该选择 x4 的模型。

带有 `animevideo` 的几个模型是针对二次元视频使用的，特点是模型文件较小以及处理速度较快（我自己的测试是 `realesrgan-x4plus-anime` 的 1.5x 到 3x 不等）。不过这个 GUI 并不会考虑加入视频处理功能，如果需要放大视频的话可以考虑使用 [VapourSynth 的相关插件](https://github.com/HolyWu/vs-realesrgan)，并且确定你的显卡不会跑到冒烟……

### 拆分大小的作用

对应原版的 `-t tile-size` 参数。“自动设定”已经可以满足日常使用了，但是如果想要自己设定的话，在显存充足的情况下建议使用较大的值，处理速度更快，放大后的图片质量更好，细节更多（虽然可能不太明显）。

将 Real-ESRGAN-ncnn-vulkan 自带的 [256x256 的测试图](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg)使用 `realesrgan-x4plus` 模型在 TTA 模式下放大到 4x，选择不同的拆分大小的效果：[32](https://user-images.githubusercontent.com/47057319/168460056-1aaf420a-c2d0-4bbf-a350-703f69cd947f.png)，[256 或以上](https://user-images.githubusercontent.com/47057319/168460053-0c34296f-a5c7-447c-9f34-e86b6ebc7035.png)。

### TTA 模式的作用

理论上可以稍微提升放大后的图片的质量，但是实际上效果非常不明显，还会使处理时间增加数倍，因此一般情况下没有开启的必要。

我自己选择了几张 1200px 以上的高清二次元图片进行实验：先将原图缩小到 1/4，再使用 `realesrgan-x4plus-anime` 模型在使用或不使用 TTA 的情况下放大 4x，比较放大后图片和原图的 SSIM（范围为 0-1，值越大表示两张图越相似）。结果使用 TTA 的 SSIM 仅比不使用高出 0.002 左右，目视就更看不出差异了。

### 高级设定中“针对 GIF 的透明色进行额外处理”是什么？

GIF 只支持最多 256 种 RGB 颜色的调色板并设定其中一种颜色为透明色（可选），也就是说不存在半透明的情况。对于存在透明部分的 GIF，这就出现了两个问题：

* 图像的 Alpha 通道只有 0 和 255 两个值，可以用只有黑白两色的图像表示，有严重的锯齿。
* 将 GIF 的每一帧拆出来保存为 PNG、WebP 等格式以后，透明部分在 RGB 通道上的颜色会变得不可预料。例如 GIF 中被设为透明色的颜色原本是 `#FFFFFF`，将帧另存为后可能会变成 `#000000`，虽然只看图片的话并没有区别。

对于使用 Real-ESRGAN 直接放大 GIF 的每一帧的做法（[示例](https://user-images.githubusercontent.com/47057319/170273973-d9743d66-d6df-42c2-8fe8-b123fa6edb98.gif)），上面两个问题的影响是：

* Real-ESRGAN 对 Alpha 通道放大的效果非常不理想，和使用常规缩放算法几乎没有区别，导致放大后的帧周围会出现一圈锯齿比较明显的杂边。
* 杂边的颜色是不可预料的，比如有些情况下是黑色，会显得非常难看。

这个选项就是针对这两个问题而添加的，启用后会添加以下操作：

* 在拆出 GIF 的每一帧时，强制把透明部分的颜色设为白色，这样可以将放大后的 GIF 的杂边颜色固定为白色，比较美观。
* 对于每一帧的 Alpha 通道，先添加半径 3px 的高斯模糊以平滑锯齿，然后应用一个增加对比度的曲线（或者是 LUT）以尽可能减小杂边的影响，再通过仿色算法处理为只有 0 和 255 两个值的黑白图像。

这个选项是实验性的，建议在放大存在透明部分的 GIF 时手动开启，在放大不存在透明部分的 GIF 时关闭。可能是由于这里的实现或 Pillow 对 GIF 的处理存在问题，在开启时处理后者会出现一些奇怪的问题（主要是出现不该出现的透明色以及仿色效果非常差）。也许会有更好的处理方法。

## 借物表

* [Pillow](https://github.com/python-pillow/Pillow)
* [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) 原版工具
* [Sun-Valley-ttk-theme](https://github.com/rdbende/Sun-Valley-ttk-theme) Windows 11 风格的 tkinter 主题，在原版基础上将所有控件的图片打包成了单张 Sprite Sheet，具体操作参见[这里](https://github.com/rdbende/Sun-Valley-ttk-theme/issues/30)
* [TkInterDnD2](https://github.com/pmgagne/tkinterdnd2) Tkinter 的拖拽支持
* [darkdetect](https://github.com/albertosottile/darkdetect) 检测是否正在使用深色模式
* [pyinstaller](https://github.com/pyinstaller/pyinstaller)