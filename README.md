# Real-ESRGAN GUI

[![build](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml/badge.svg)](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml)

实用、美观的图片放大工具 Real-ESRGAN 的图形界面，参考 [waifu2x-caffe](https://github.com/lltcggie/waifu2x-caffe) 设计。

![](https://user-images.githubusercontent.com/47057319/166252452-d3e7dfbd-2e91-4aaa-95bd-0937adb3d00b.png)

## 基本介绍

这个程序是 Real-ESRGAN 的命令行程序 [Real-ESRGAN-ncnn-vulkan](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan) 的图形界面，使用 Python 和 tkinter 编写。

使用时请将这里的所有文件或打包后的可执行文件和 Real-ESRGAN-ncnn-vulkan 的可执行文件放在同一个目录。从源代码运行前，请使用 `pip install -r requirements.txt` 安装依赖。

> 可以在 [Release](https://github.com/TransparentLC/realesrgan-gui/releases) 下载适用于 Windows 10 和 Ubuntu 20.04（或更新版本系统）的打包好的版本。
>
> 文件名包含 `bundled` 的压缩包整合了 Real-ESRGAN-ncnn-vulkan 的可执行文件和模型，这样就不需要另外下载了。

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

## 效果对比

| Nearest Neighbor | Lanczos | waifu2x-caffe | Real-ESRGAN |
| --- | --- | --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/166262181-cf1e6c02-a8d2-4d49-88d9-1dfe65107c18.png) | ![](https://user-images.githubusercontent.com/47057319/166262508-32010b72-76b1-4edb-ba8a-f850283873ea.png) | ![](https://user-images.githubusercontent.com/47057319/166262200-a350b33b-9ebb-4159-889c-38d9d5bba386.png) | ![](https://user-images.githubusercontent.com/47057319/166262192-735fb21b-7452-48fe-b99d-ed8233af6d31.png) |

| Nearest Neighbor | Lanczos | waifu2x-caffe | Real-ESRGAN |
| --- | --- | --- | --- |
| ![](https://user-images.githubusercontent.com/47057319/166262217-7623a30d-e4e9-46e4-a869-1dcabdbbd74e.png) | ![](https://user-images.githubusercontent.com/47057319/166262210-a836ed72-b197-4f5f-bcfd-3e459ebf5776.png) | ![](https://user-images.githubusercontent.com/47057319/166262243-810b894d-657d-4a84-84bb-88e76845404f.png) | ![](https://user-images.githubusercontent.com/47057319/166262229-6bc75e4b-9980-4c14-b4e4-4c0d53642a35.png) |

* waifu2x-caffe 使用 UpResNet10 和 UpPhoto 模型，降噪等级 3，开启 TTA。
* Real-ESRGAN 使用 realesrgan-x4plus-anime 和 realesrgan-x4plus 模型，开启 TTA。
* 放大倍率均为 4x。

## 借物表

* [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) 原版工具
* [Sun-Valley-ttk-theme](https://github.com/rdbende/Sun-Valley-ttk-theme) Windows 11 风格的 tkinter 主题
