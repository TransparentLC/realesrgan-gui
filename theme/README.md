[Sun-Valley-ttk-theme](https://github.com/rdbende/Sun-Valley-ttk-theme) 的各个控件上的图案是以图片的方式保存的，浅色和深色主题一共有一百多个小文件。

为了避免读取和写入这些零碎的小文件，这里将所有的图片文件使用 [TexturePecker](https://www.codeandweb.com/texturepacker) 拼成一张 Sprite Sheet（`sprites.png`），并以 JSON 格式导出单个图片的位置和尺寸数据（`sprites.json`）。运行 `extract.py` 可以读取这些数据并生成从 Sprite Sheet 中读取各个图片的 tcl 代码，替代主题中从大量小文件中读取的做法。