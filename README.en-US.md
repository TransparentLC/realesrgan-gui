# Real-ESRGAN GUI

[![build](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml/badge.svg)](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml)
[![download](https://img.shields.io/github/downloads/TransparentLC/realesrgan-gui/total.svg)](https://github.com/TransparentLC/realesrgan-gui/releases)

A cross-platform GUI for image upscaler [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) with additional features. Inspired by [waifu2x-caffe](https://github.com/lltcggie/waifu2x-caffe).

<details>

<summary>README translations</summary>

* [简体中文 (Simplified Chinese)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.md)
* [English](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.en-US.md)
* [Ukrainian (Українська)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.uk-UA.md) Translated by [@kirill0ermakov](https://github.com/kirill0ermakov)
* [Türkçe (Turkish)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.tr-TR.md) Translated by [@NandeMD](https://github.com/NandeMD) tarafından

</details>

<picture>
    <source media="(prefers-color-scheme:dark)" srcset="https://user-images.githubusercontent.com/47057319/219046059-6611f26b-c558-436e-a1d2-9576d355c2c6.png">
    <img src="https://user-images.githubusercontent.com/47057319/219046017-467f4020-5257-4938-9bfe-b6ab6c65b706.png">
</picture>

## Introduction

This application uses Real-ESRGAN's portable executable file ([Real-ESRGAN-ncnn-vulkan](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan)) to upscale images with extremely high quality. It is written in Python and provides an user-friendly GUI with Tkinter.

Quick Start：

* ![Windows 10+](https://img.shields.io/badge/Windows-10+-06b?logo=windows) Download the latest `realesrgan-gui-windows-bundled-v*.7z` from Release, extract the archive then launch `realesrgan-gui.exe`.
* ![Ubuntu 22.04+](https://img.shields.io/badge/Ubuntu-22.04+-e52?logo=ubuntu) Download the latest `realesrgan-gui-ubuntu-bundled-v*.tar.xz` from Release, extract the archive then launch `realesrgan-gui`.
* ![macOS Monterey+](https://img.shields.io/badge/macOS-Monterey+-111?logo=apple) Download the latest `realesrgan-gui-macos-appbundle-v*.tar.xz` from Release, extract the archive and run `chmod u+x "Real-ESRGAN GUI.app/Contents/MacOS/realesrgan-gui"`, `chmod u+x "Real-ESRGAN GUI.app/Contents/MacOS/realesrgan-ncnn-vulkan"` and `xattr -cr "Real-ESRGAN GUI.app"` in terminal, then launch `Real-ESRGAN GUI`.

> [!TIP]
> Real-ESRGAN-ncnn-vulkan has not been updated for a while since April 2022. You can use another actively maintained fork [upscayl/upscayl-ncnn](https://github.com/upscayl/upscayl-ncnn) instead.
>
> Download the latest release and extract `upscayl-bin[.exe]` to the directory where Real-ESRGAN GUI's executable file is located. It will be used in priority.

> [!TIP]
> You can alse use [Real-CUGAN](https://github.com/bilibili/ailab/tree/main/Real-CUGAN) in Real-ESRGAN GUI for upscaling! See this [section](#) for details.

<details>

<summary>Notes</summary>

* Real-ESRGAN-ncnn-vulkan's executable file and models are not contained in  `realesrgan-gui-windows.7z` and `realesrgan-gui-ubuntu.tar.xz`. You have to download manually from [here](https://github.com/xinntao/Real-ESRGAN/releases) and extract them to the directory where Real-ESRGAN GUI's executable file is located.
* The artifacts in GitHub Actions are built based on the latest commits. They don't contain Real-ESRGAN-ncnn-vulkan's executable file and models either.
* Use Python 3.10 or above if you want to run Real-ESRGAN GUI from source. Don't forget to install the dependcies by `pip install -r requirements.txt` and extract Real-ESRGAN-ncnn-vulkan to the repository before running `python main.py`.
* It may be possible to run Real-ESRGAN GUI in other Linux distributions, but I have not tested it.

</details>

Please check out [CONTRIBUTING.md](https://github.com/TransparentLC/realesrgan-gui/blob/master/CONTRIBUTING.md) if you would like to contribute to Real-ESRGAN GUI.

### Build `Real-ESRGAN GUI.app` for Apple Silicon (`arm64`)

The `arm64` builds have been tested to perform better than `universal2` builds. If you are using Apple Silicon, it is recommended that you can make an `arm64` build by yourself.

```shell
# 1. Clone this repository.
git clone https://github.com/TransparentLC/realesrgan-gui.git
cd realesrgan-gui

# 2. Run the shell script to start building. Since the latest commit of this project requires tk version 8.6, while Python 3.10 bundles tk version 8.5, the local packaging must be done in Python 3.11 environment. Before packaging, enter python3 -V in the terminal to confirm the current version is 3.11.
# Password is required for "sudo pyinstaller realesrgan-gui-macOS-arm64.spec"
sh Build-macOS-arm64.sh

# 3. The built application is saved in "./realesrgan-gui/dist/Real-ESRGAN GUI.app".
```

> [!WARNING]
> Since I don't have any device running macOS, I may not be able to handle macOS-related issues.

### Related projects

* Use Real-ESRGAN on Android: [tumuyan/RealSR-NCNN-Android](https://github.com/tumuyan/RealSR-NCNN-Android)
* Upscale video with Real-ESRGAN and Vapoursynth: [HolyWu/vs-realesrgan](https://github.com/HolyWu/vs-realesrgan)

## Features

In addition to the features supported by Real-ESRGAN-ncnn-vulkan, Real-ESRGAN GUI also supports these additional features:

* Upscale to arbitrary size
    * Real-ESRGAN-ncnn-vulkan can only upscale the input image at a fixed 2-4x ratio (depending on the model chosen).
    * Real-ESRGAN GUI uses Real-ESRGAN-ncnn-vulkan to upscale the input image  in multiple times, then downsamples the output image to the desired size  with general image scaling algorithms.
    * For example, to upscale a 640x360 image to 1600 in width with a 2x model, it will be upscaled twice to 1280x720 and 2560x1440 then downsampled to 1600x900.
    * Lanczos is used by default to downsample the image. Other algorithms are also available.
* Upscale GIF images
    * Split animated GIF into frames and reads their duration. Upscale the frames one by one then merge them into upscaled animated GIF image.
* Drag and drop support
    * Drag and drop image files or directories onto the GUI and the input and output path will be set automatically.
    * The output path will contain a suffix like x4, w1280, h1080 based on the chosen resize mode.
* Dark theme
    * Choose to use light or dark theme according to system settings.
    * The detection is done using [darkdetect](https://github.com/albertosottile/darkdetect).
    * Not available on macOS?
* Multi-language support
    * Simplified and traditional Chinese and English are currently supported.
    * Uses `locale.getdefaultlocale` for language detection.
    * Fallback to English by default if translated text is missing.
    * You can add or improve translations by editing [`i18n.ini`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.ini). Contributions are very welcome!
        * After adding your language to [`i18n.ini`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.ini), run the [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py) file and copy the `locales_map` variable from the output until the end. Then, replace the variable in [`i18n.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.py) with the one you copied. If you encounter any issues running [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py), try running `pip install -r requirements.txt` in the command line to install the necessary dependencies, and then try again.
        * If you don't want to deal with [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py), you can directly add your language code and the visible name of your language to the `locales_map` variable in the [`i18n.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.py) file.

## Samples

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

* waifu2x-caffe samples are upscaled using `UpResNet10` and `UpPhoto` models with noise reduction level 3 and TTA enabled.
* Real-ESRGAN samples are upscaled using `realesrgan-x4plus-anime` and `realesrgan-x4plus` models with TTA enabled.
* The original images are upscaled to 4x.
* The displayed GIFs are lossy compressed to reduce the file size.

## Frequently asked questions

### Which model should I choose?

I recommend `realesrgan-x4plus` for real-life photos and `realesrgan-x4plus-anime` for anime images.

For different upscale ratio versions of the same model, it is recommended to choose the version that is equal to or greater than the ratio at which you want to enlarge the image. For example, if a model has x2 and x4 version and you want to upscale an image by 3x, you should choose the x4 version.

Models with `animevideo` in the filename are designed for anime videos. These models are small and have a faster processing speed (about 1.5-3x compare to `realesrgan-x4plus-anime`). However, Real-ESRGAN GUI will not consider adding video processing related features.

You can download additional models from [here](https://github.com/TransparentLC/realesrgan-gui/releases/tag/additional-models) and place the `bin` and `param` files in the `models` directory to install. These model may produce better (or worse) results than the official models for some images, especially for real-life photos.

### The usage of tile size

Corresponding to Real-ESRGAN-ncnn-vulkan's `-t tile-size` param. You can choose "auto" in most cases, or use a larger value if you have enough VRAM. Larger tile size can slightly increase processing speed and the upscaled image's quality, although it may not be obvious.

You can check the difference between the two images upscaled to 4x with tile size [32](https://user-images.githubusercontent.com/47057319/168460056-1aaf420a-c2d0-4bbf-a350-703f69cd947f.png) and [256](https://user-images.githubusercontent.com/47057319/168460053-0c34296f-a5c7-447c-9f34-e86b6ebc7035.png) from the [256x256 test image](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg) comes with Real-ESRGAN-ncnn-vulkan.

See [#32](https://github.com/TransparentLC/realesrgan-gui/issues/32#issuecomment-1547148843) (in Chinese) for more details on this.

### The usage of TTA mode

Slightly improve the quality of upscaled image, but the effect is actually very insignificant. The processing speed will become extremely slow if TTA mode is enabled, so it is not recommended to enable it.

I downloaded some anime images larger than 1200px to conduct an experiment: downsample the image to 1/4 then upscale them with `realesrgan-x4plus-anime` model, measure upscaling quality by SSIM compared with the original image. The TTA-enabled image's SSIM is only about 0.002 higher than TTA-not-enabled image. It is difficult to see the difference with eyes.

### What is "additional processing for GIF with transparency"?

GIFs only support a palette of up to 256 RGB colors and set one of them to be transparent (optional), which means that there is no translucency. For GIFs with transparent parts, this raises two problems.

* The Alpha channel of the image has only two values, 0 and 255, and can be represented by an image with only black and white colors, with severe jaggies.
* The color of the transparent part on the RGB channel becomes unpredictable after each frame of a GIF is split out and saved as a PNG, WebP, etc. For example, the color set as transparent in a GIF is originally #FFFFFF, but after saving the frame it may become #000000, although it makes no difference if you just look at the image.

For upscaling GIF images using Real-ESRGAN directly ([Example](https://user-images.githubusercontent.com/47057319/170273973-d9743d66-d6df-42c2-8fe8-b123fa6edb98.gif)), the impact of the two problems above are:

* The upscaled alpha channel's quality is very poor, resulting in a jagged ring around the scaled frame.
* The color of the jagged ring is unpredictable, for example black in some cases and looks very ugly.

This option was added to resolve these issues. It adds the following actions:

* Force the color of the transparent part to be white when splitting out each frame of the GIF.
* Add a 3px Gaussian blur and apply a contrast curve to smooth out the jagged rings in the alpha channel. Then dither the alpha channel to a black and white image with only 0 and 255 values.

This option is experimental and it is recommended to enable it only when upscaling GIFs with transparency.

### About lossy compression, compression quality and custom compression/post-processing command

If lossy compression is enabled and the output format is JPEG or WebP, you can control the compression quality of the output image to the set value. If the input is a directory, the output compression quality will also be affected by this option when upscaling JPEG or WebP images in the directory. The compression is done using Pillow.

If this option is not turned on, lossless compression is used when the output is in WebP format.

If custom compression/post-processing command is set, the Pillow's compression will not be performed. You can set a command to compress the upscaled image or do other processing with it.

* `{input}` represents the path of the input file.
* `{output}` represents the path of the output file.
* `{output:ext}` represents the path of the output file with the extension `ext`.
* Cookbook:
    * Use [avifenc (libavif)](https://github.com/AOMediaCodec/libavif/blob/main/doc/avifenc.1.md) to convert to AVIF: `avifenc --speed 6 --jobs all --depth 8 --yuv 420 --min 0 --max 63 -a end-usage=q -a cq-level=30 -a enable-chroma-deltaq=1 --autotiling --ignore-icc --ignore-xmp --ignore-exif {input} {output:avif}`
    * Use [cjxl (libjxl)](https://github.com/libjxl/libjxl#usage) to convert to JPEG XL: `cjxl {input} {output:jxl} --quality=80 --effort=9 --progressive --verbose`
    * Use [gif2webp (libwebp)](https://developers.google.com/speed/webp/docs/gif2webp) to convert the output GIF to WebP: `gif2webp -lossy -q 80 -m 6 -min_size -mt -v {input} -o {output:webp}`
    * Use [ImageMagick](https://imagemagick.org/) to add a text watermark in the lower-right corner and then convert to AVIF: `magick convert -fill white -pointsize 24 -gravity SouthEast -draw "text 16 16 'https://github.com/TransparentLC/realesrgan-gui'" -quality 80 {input} {output:avif}`

### Where the configuration file is saved?

`config.ini` in the repository's directory or in the directory where Real-ESRGAN GUI's executable is located, without this file the default configuration is used.

The configuration will be saved automatically when exiting the program.

### Additional models

You can download additional models from [Upscale Wiki](https://upscale.wiki/wiki/Model_Database) and use them in Real-ESRGAN GUI. These model may produce better (or worse) results than the official model for some images.

These model uses PyTorch's `pth` format, but Real-ESRGAN GUI (Real-ESRGAN-ncnn-vulkan) needs NCNN's `bin` and `param` format. You can follow this [guide](https://note.youdao.com/ynoteshare/?id=2b001cd4175ab46d2ce11ecb5a6d84ff) (written by RealSR-NCNN-Android's author in Chinese) to make a conversion with [cupscale](https://github.com/n00mkrad/cupscale)'s `pth2ncnn` utility. The model's filename must contain its upscale factor like `x4` or `4x`.

You can download some converted additional models from [here](https://github.com/TransparentLC/realesrgan-gui/releases/tag/additional-models).

### I think Real-CUGAN performs better in upscaling than Real-ESRGAN

Someone recommends it. So I added support for it.

Follow these steps if you want to use Real-CUGAN instead of Real-ESRGAN:

* Download [Real-CUGAN-ncnn-vulkan](https://github.com/nihui/realcugan-ncnn-vulkan).
* Set `upscaler` in `config.ini` to the path of `realcugan-ncnn-vulkan[.exe]`.
* Put Real-CUGAN's models (the `models-{nose,pro,se}` folders) into the `models` folder (or the directory specified by `modeldir` in `config.ini`).

### Why not (other similar GUI)?

Of course, there is more than one GUI for Real-ESRGAN. Here is a list of some, with reasons why I didn't use them and decided to build on my own.

#### [Waifu2x-Extension-GUI](https://github.com/AaronFeng753/Waifu2x-Extension-GUI) ![](https://img.shields.io/github/stars/AaronFeng753/Waifu2x-Extension-GUI)

This is an all-in-one toolbox that integrates tons of tools, including waifu2x, Anime4k, Real-SR, SRMD, Real-ESRGAN, Real-CUGAN ... for image upscaling and CAIN, DAIN, RIFE ... for video frame interpolation and other utils including ffmpeg, ImageMagick, gifsicle, nircmd, wget and more. Only supported on Windows.

The rich feature set leads to a complex UI and configurations, however I only need a small number of its features. I used to be a user of it when it was open source, but then the author [modified LICENSE](https://github.com/AaronFeng753/Waifu2x-Extension-GUI/commit/) and [switched to closed source](https://github.com/AaronFeng753/Waifu2x-Extension-GUI/commit/38b13ed886f50d861798e8cad3cc056f04173415) since v3.41.01 in May 2021. Moreover, the advertisement of the premium version appears every time when it starts up and finishes processing.

Although I don't rely on those premium-only features, the changes still encourages me to write another lightweight GUI that meets my needs.

#### [upscayl](https://github.com/upscayl/upscayl) ![](https://img.shields.io/github/stars/upscayl/upscayl)

Built with Electron, so it is also cross-platform. Benefiting from the power of front-end technologies, the UI and interaction are excellent and there is even a comparison slider between the original image and the upscaled image. The documentation is also very detailed.

However, it still lacks some features such as handling GIFs, customizing post-processing commands, and [localization](https://github.com/upscayl/upscayl/issues/91).

Since it is an Electron application, the users will have to [install yet another Chromium browser](https://github.com/ShirasawaSama/CefDetector/raw/master/screenshot.png)😂 The size of Upscayl is about 400 MB while Real-ESRGAN GUI is only about 10 MB (Windows version, excluding Real-ESRGAN-ncnn-vulkan's executable and models).

#### [tsukumijima/Real-ESRGAN-GUI](https://github.com/tsukumijima/Real-ESRGAN-GUI) ![](https://img.shields.io/github/stars/tsukumijima/Real-ESRGAN-GUI)、[net2cn/Real-ESRGAN_GUI](https://github.com/net2cn/Real-ESRGAN_GUI) ![](https://img.shields.io/github/stars/net2cn/Real-ESRGAN_GUI)、[upscale-rs](https://github.com/oloko64/upscale-rs) ![](https://img.shields.io/github/stars/oloko64/upscale-rs)、[Real-ESRGAN-EGUI](https://github.com/WGzeyu/Real-ESRGAN-EGUI) ![](https://img.shields.io/github/stars/WGzeyu/Real-ESRGAN-EGUI) ……

These GUIs are simple wrappers for the CLI parameters without any extra features.

However, I like the Material Design used by tsukumijima/Real-ESRGAN-GUI. It also supports Real-CUGAN.

## Open-source libraries used

* [Pillow](https://github.com/python-pillow/Pillow)
* [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN)
* [Sun-Valley-ttk-theme](https://github.com/rdbende/Sun-Valley-ttk-theme)
* [TkInterDnD2](https://github.com/pmgagne/tkinterdnd2)
* [darkdetect](https://github.com/albertosottile/darkdetect)
* [pyinstaller](https://github.com/pyinstaller/pyinstaller)

## Credits

Thanks [@blacklein](https://github.com/blacklein) and [@hyrulelinks](https://github.com/hyrulelinks) for offering helps on using and bundling this application in macOS.

And other contributors!

[![Contributors](https://contrib.rocks/image?repo=TransparentLC/realesrgan-gui)](https://github.com/TransparentLC/realesrgan-gui/graphs/contributors)

## Star history

<a href="https://star-history.com/#TransparentLC/realesrgan-gui&Date">
  <picture>
    <source media="(prefers-color-scheme:dark)" srcset="https://api.star-history.com/svg?repos=TransparentLC/realesrgan-gui&type=Date&theme=dark" />
    <source media="(prefers-color-scheme:light)" srcset="https://api.star-history.com/svg?repos=TransparentLC/realesrgan-gui&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=TransparentLC/realesrgan-gui&type=Date" />
  </picture>
</a>
