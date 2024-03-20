# 贡献这个项目

[English version](#Contributing)

感谢你对 Real-ESRGAN GUI 这个项目的贡献～

如果你认为 Real-ESRGAN GUI 帮到了你，除了做出贡献以外，也可以通过以下方式表达对我的支持：

* 为这个项目点 ⭐Star
* 在你的个人网站或微信公众号等平台介绍 Real-ESRGAN GUI
  * 但是，请不要使用“关注可见”、“回复可见”甚至是“付费可见”这样的方式
* 在你发布使用 Real-ESRGAN GUI 处理的图片时，添加“使用了 Real-ESRGAN GUI 进行放大”这样的介绍，并且附上这个项目的链接

## 报告 Bug，请求新功能，或是其他的问题

请先查找[已有的 Issue](https://github.com/TransparentLC/realesrgan-gui/issues?q=is%3Aissue)，看看是否有人已经提出了类似的问题。如果仍然有疑问的话，你可以[提交新的 Issue](https://github.com/TransparentLC/realesrgan-gui/issues/new)。

如果你遇到了 bug，请提供你认为与 bug 有关的重要信息，例如运行环境、日志输出、复现过程、会触发的 bug 的图片等。

> [!TIP]
> 请确认你遇到的 bug 确实与这个 GUI 相关，而不是来自 Real-ESRGAN 本身。
>
> 例如，在 Real-ESRGAN 处理失败时你可能会在 GUI 看到 `subprocess.CalledProcessError: Command ... returned non-zero exit status ...` 这样的输出，你可以在命令行中自行执行相关命令来验证这是否为 Real-ESRGAN 本身的问题。

如果你希望添加新功能，请在动手之前先在 Issue 中进行讨论。你可以介绍这一功能的细节，可以起到的作用等。

> [!TIP]
> 与其他将大量超分辨率技术整合到一起的 GUI 相比，Real-ESRGAN GUI 的目标是尽可能做到实用又不失简洁和轻量，因此目前不会考虑加入对其他超分辨率技术的支持。

你也可以自行修复 bug 或实现新功能并提交 Pull Requests，在 merge 之前我可能会提出 review。

## 添加或改进翻译

Real-ESRGAN GUI 使用符合 BCP 47 的语言标识，例如 `zh-CN`、`en-US` 等。如果不同语言的翻译存在差异，请以简体中文翻译为准。

### 翻译 README

在翻译后的文件名中添加语言标识，例如 `README.en-US.md`。

在所有 README 开头的“README translations”部分添加指向你翻译的文件的链接（你可以写上你的用户名），注意“README translations”和“Translated by”无需翻译：

```diff
<details>

<summary>README translations</summary>

* [简体中文 (Simplified Chinese)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.md)
+ * [English](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.en-US.md)
+ * [Ukrainian (Українська)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.uk-UA.md) Translated by [@kirill0ermakov](https://github.com/kirill0ermakov)

</details>
```

修改 [`.github/workflows/build.yml`](https://github.com/TransparentLC/realesrgan-gui/blob/master/.github/workflows/build.yml)，在打包过程中添加你翻译的文件：

```diff
release:
  steps:
    ...
    - name: Create release assets
      id: vars
      run: |
        ...
        if [ $BUILD_OS == "macOS" ]; then
          cp ../../../../README.md README_gui.md
+         cp ../../../../README.en-US.md README_gui.en-US.md
        else
          cp ../README.md README_gui.md
+         cp ../README.en-US.md README_gui.en-US.md
        fi
        ...
```

### 翻译 GUI 的文本

在 [`i18n.ini`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.ini) 中添加你要翻译的语言标识（可能不止一个），然后填写你翻译的内容。

```ini
[en_US, en_GB]
Input = Input (file or folder)
Output = Output
ToastCompletedMessage = The files have been saved to: {0}
                        Elapsed time: {1:.03f}s
...
```

`{0}` 和 `{1:.03f}` 这样的部分是格式化字符串的标识符（replacement fields），需要保留。在翻译缺失的情况将回退到英语。

然后，你需要执行 [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py)（需要另外安装依赖 `babel`）生成所有语言的可见名称，填写到 [`i18n.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.py) 用于在 GUI 中选择语言：

```py
locales_map = {
    '中文 (简体, 中国)': 'zh_CN',
    'English (United States)': 'en_US',
    ...
}
```

# Contributing

Thanks for taking the time to contribute to this repository!

If you like Real-ESRGAN GUI, you can also show your appreciation in the following ways, which I would also be happy about:

* ⭐Star this repository
* Recommend Real-ESRGAN GUI on your website, blog, social media, etc.
  * However, please don't put this repository's link behind any sort of paywall
* Add "Upscaled with Real-ESRGAN GUI" and this repository's link to the description if you are publishing images upscaled with Real-ESRGAN GUI

## Bug report, feature requests, or other questions

Search for [existing issues](https://github.com/TransparentLC/realesrgan-gui/issues?q=is%3Aissue) that might help you at first. If you still feel the need to ask a question and need clarification, you can open a [new issue](https://github.com/TransparentLC/realesrgan-gui/issues/new).

When submitting bug reports, please provide any important information you think is relevant to the bug. For example, the environment, log outputs, detailed steps to reproduce the bug, and the image that triggers the bug.

> [!TIP]
> Make sure that your bug is really related to this GUI and not from Real-ESRGAN itself.
>
> You might see `subprocess.CalledProcessError: Command ... returned non-zero exit status ...` from the GUI's output when Real-ESRGAN failed to process the image. You can determine if this bug is from Real-ESRGAN itself by executing the commands in the command line.

Before working on new features, please open an issue to discuss it at first. You can provide details of your feature request, describe the behavior you are expected to see and explain why this feature would be beneficial to you and other users.

> [!TIP]
> In contrast to other all-in-one GUIs which integrate a large number of upscalers (or super-resolution tools), Real-ESRGAN GUI aims to be as practical as possible while still being simple and lightweight. Therefore I have no plans to support other upscalers.

You can fix the bug or implement the new feature by yourself and submit a pull request. I might start reviews before merging it.

## Improving translations

Real-ESRGAN GUI uses BCP 47 language tags e.g. `zh-CN`, `en-US`. Please refer to the Simplified Chinese translation in case of differences between translations in different languages.

### Translating README

Add the language tag you want to translate in the filename like `README.en-US.md`.

Add a link to your translation (and your username) in all READMEs' "README translations" section at the beginning. Note that "README translations" and "Translated by" do not need to be translated.

```diff
<details>

<summary>README translations</summary>

* [简体中文 (Simplified Chinese)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.md)
+ * [English](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.en-US.md)
+ * [Ukrainian (Українська)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.uk-UA.md) Translated by [@kirill0ermakov](https://github.com/kirill0ermakov)

</details>
```

Edit [`.github/workflows/build.yml`](https://github.com/TransparentLC/realesrgan-gui/blob/master/.github/workflows/build.yml) to include your translation in the release.

```diff
release:
  steps:
    ...
    - name: Create release assets
      id: vars
      run: |
        ...
        if [ $BUILD_OS == "macOS" ]; then
          cp ../../../../README.md README_gui.md
+         cp ../../../../README.en-US.md README_gui.en-US.md
        else
          cp ../README.md README_gui.md
+         cp ../README.en-US.md README_gui.en-US.md
        fi
        ...
```

### Translating the GUI

Add the language tags you want to translate (there may be more than one) in [`i18n.ini`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.ini) and fill the values with your translations.

```ini
[en_US, en_GB]
Input = Input (file or folder)
Output = Output
ToastCompletedMessage = The files have been saved to: {0}
                        Elapsed time: {1:.03f}s
...
```

String replacement fields like `{0}` and `{1:.03f}` should be preserved. Fallback to English by default if translated text is missing.

After the translation is completed, run [`generate_locales_map.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/generate_locales_map.py) (requires installing the `babel` package) to generate code of the `locales_map` variable including visible names of translated languages and replace the code in [`i18n.py`](https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.py).

```py
locales_map = {
    '中文 (简体, 中国)': 'zh_CN',
    'English (United States)': 'en_US',
    ...
}
```