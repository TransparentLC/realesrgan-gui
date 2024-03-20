# Real-ESRGAN GUI

[![build](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml/badge.svg)](https://github.com/TransparentLC/realesrgan-gui/actions/workflows/build.yml)
[![download](https://img.shields.io/github/downloads/TransparentLC/realesrgan-gui/total.svg)](https://github.com/TransparentLC/realesrgan-gui/releases)

Кросплатформенний графічний інтерфейс для апскейлера зображень [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN) з додатковими можливостями. За мотивами [waifu2x-caffe](https://github.com/lltcggie/waifu2x-caffe).

<details>

<summary>README переклади</summary>

* [简体中文 (Simplified Chinese)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.md)
* [English](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.en-US.md)
* [Ukrainian (Українська)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.uk-UA.md) Translated by [@kirill0ermakov](https://github.com/kirill0ermakov)
* [Türkçe (Turkish)](https://github.com/TransparentLC/realesrgan-gui/blob/master/README.tr-TR.md) Translated by [@NandeMD](https://github.com/NandeMD) tarafından

</details>

<picture>
    <source media="(prefers-color-scheme:dark)" srcset="https://user-images.githubusercontent.com/47057319/219046059-6611f26b-c558-436e-a1d2-9576d355c2c6.png">
    <img src="https://user-images.githubusercontent.com/47057319/219046017-467f4020-5257-4938-9bfe-b6ab6c65b706.png">
</picture>

## Вступ

Ця програма використовує портативний виконуваний файл Real-ESRGAN ([Real-ESRGAN-ncnn-vulkan](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan)) для підвищення якості зображень з надзвичайно високою якістю. Вона написана на мові Python і надає зручний графічний інтерфейс за допомогою Tkinter.

Quick Start：

* ![Windows 10+](https://img.shields.io/badge/Windows-10+-06b?logo=windows) Завантажте останній `realesrgan-gui-windows-bundled-v*.7z` з релізу, розпакуйте архів та запустіть `realesrgan-gui.exe`.
* ![Ubuntu 22.04+](https://img.shields.io/badge/Ubuntu-22.04+-e52?logo=ubuntu) Завантажте найновіший `realesrgan-gui-ubuntu-bundled-v*.tar.xz` з релізу, розпакуйте архів і запустіть `realesrgan-gui`.
* ![macOS Monterey+](https://img.shields.io/badge/macOS-Monterey+-111?logo=apple) Завантажте останню версію `realesrgan-gui-macos-appbundle-v*.tar.xz` з релізу, розпакуйте архів і виконайте `xattr -cr "Real-ESRGAN GUI.app"` у терміналі, потім запустіть `Real-ESRGAN GUI`.

<details>

<summary>Примітки</summary>

* Виконуваний файл та моделі Real-ESRGAN-ncnn-vulkan не містяться у файлах `realesrgan-gui-windows.7z` та `realesrgan-gui-ubuntu.tar.xz`. Їх необхідно завантажити вручну з [тут] (https://github.com/xinntao/Real-ESRGAN/releases) та розпакувати в каталог, де знаходиться виконуваний файл Real-ESRGAN GUI.
* Артефакти в GitHub Actions побудовані на основі останніх коммітів Вони також не містять виконуваного файлу та моделей Real-ESRGAN-ncnn-vulkan.
* Використовуйте Python 3.10 або новішої версії, якщо ви хочете запустити Real-ESRGAN GUI з коду. Не забудьте встановити залежності за допомогою `pip install -r requirements.txt` та розпакувати Real-ESRGAN-ncnn-vulkan до репозиторію перед запуском `python main.py`.
* Можливо, Real-ESRGAN GUI можна запустити і в інших дистрибутивах Linux, але я не перевіряв.

</details>

> ⚠️ Оскільки у мене немає жодного пристрою під управлінням macOS, можливо, я не зможу вирішити проблеми, пов'язані з macOS.

## Особливості

На додаток до функцій, що підтримуються Real-ESRGAN-ncnn-vulkan, Real-ESRGAN GUI також підтримує ці додаткові функції:

* Масштабування до довільного розміру
    * Real-ESRGAN-ncnn-vulkan може збільшувати вхідне зображення лише у фіксованому співвідношенні 2-4x (залежно від обраної моделі).
    * Real-ESRGAN GUI використовує Real-ESRGAN-ncnn-vulkan для багаторазового збільшення вхідного зображення, а потім зменшує вихідне зображення до потрібного розміру за допомогою загальних алгоритмів масштабування зображень.
    * Наприклад, щоб збільшити зображення 640x360 до 1600 у ширину за допомогою моделі 2x, його буде двічі збільшено до 1280x720 та 2560x1440, а потім зменшено до 1600x900.
    * За замовчуванням для зменшення дискретизації зображення використовується алгоритм Ланчоса. Також доступні інші алгоритми.
* Збільшення масштабу GIF-зображень
    * Розбиває анімований GIF на кадри і зчитує їх тривалість. Збільшує масштаб кадрів по одному, а потім об'єднує їх у збільшене анімоване GIF-зображення.
* Підтримка перетягування
    * Перетягуйте графічні файли або каталоги на графічний інтерфейс, і вхідний і вихідний шлях будуть встановлені автоматично.
    * Вихідний шлях буде містити суфікс, такий як x4, w1280, h1080, залежно від обраного режиму зміни розміру.
* Темна тема
    * Виберіть світлу або темну тему відповідно до системних налаштувань.
    * Виявлення здійснюється за допомогою [darkdetect] (https://github.com/albertosottile/darkdetect).
    * Не доступно на macOS?
* Багатомовна підтримка
    * Наразі підтримуються спрощена та традиційна китайська та англійська мови.
    * Використовує `locale.getdefaultlocale` для визначення мови.
    * За замовчуванням повертається до англійської мови, якщо перекладений текст відсутній.
    * Ви можете додавати або покращувати переклади, редагуючи [`i18n.ini`] (https://github.com/TransparentLC/realesrgan-gui/blob/master/i18n.ini). Внески дуже вітаються!

## Зразки

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

* зразки waifu2x-caffe масштабуються з використанням моделей `UpResNet10` та `UpPhoto` з рівнем зменшення шуму 3 та увімкненим TTA.
* Зразки Real-ESRGAN збільшено за допомогою моделей realesrgan-x4plus-anime та realesrgan-x4plus з увімкненим TTA.
* Оригінальні зображення збільшено до 4x.
* Відображені GIF-файли стискаються з втратами для зменшення розміру файлу.

## Найпоширеніші запитання

### Яку модель обрати?

Я рекомендую `realesrgan-x4plus` для реальних фотографій і `realesrgan-x4plus-anime` для аніме-зображень.

Для різних версій збільшення однієї і тієї ж моделі рекомендується вибирати версію, яка дорівнює або перевищує співвідношення, в якому ви хочете збільшити зображення. Наприклад, якщо модель має версії x2 і x4, і ви хочете збільшити зображення в 3 рази, вам слід вибрати версію x4.

Моделі з `animevideo` у назві файлу призначені для аніме-відео. Ці моделі мають невеликий розмір і більш високу швидкість обробки (приблизно в 1,5-3 рази в порівнянні з `realesrgan-x4plus-anime`). Однак я рекомендую [VapourSynth](https://www.vapoursynth.com/) та його [Real-ESRGAN plugin](https://github.com/HolyWu/vs-realesrgan), якщо ви хочете підвищити якість відео. Графічний інтерфейс Real-ESRGAN не розглядає можливість додавання функцій, пов'язаних з обробкою відео.

### Використання розміру плитки

Відповідає параметру Real-ESRGAN-ncnn-vulkan `-t tile-size`. Ви можете вибрати "авто" у більшості випадків, або використовувати більше значення, якщо у вас достатньо VRAM. Більший розмір плитки може дещо підвищити швидкість обробки та якість зображення, хоча це може бути неочевидно.

Ви можете перевірити різницю між двома зображеннями, збільшеними до 4x з розміром плитки [32](https://user-images.githubusercontent.com/47057319/168460056-1aaf420a-c2d0-4bbf-a350-703f69cd947f.png) і [256](https://user-images.githubusercontent.com/47057319/168460053-0c34296f-a5c7-447c-9f34-e86b6ebc7035.png) з [256x256 тестового зображення](https://github.com/xinntao/Real-ESRGAN-ncnn-vulkan/blob/master/images/input2.jpg), що постачається з Real-ESRGAN-ncnn-vulkan.

### Використання режиму TTA

Дещо покращує якість збільшеного зображення, але насправді ефект дуже незначний. Швидкість обробки стане надзвичайно низькою, якщо увімкнути режим TTA, тому вмикати його не рекомендується.

Я завантажив кілька аніме-зображень розміром більше 1200 пікселів, щоб провести експеримент: зменшити розмір зображення до 1/4, потім збільшити його за допомогою моделі `realesrgan-x4plus-anime`, виміряти якість збільшення за допомогою SSIM у порівнянні з вихідним зображенням. SSIM зображення з підтримкою TTA лише приблизно на 0,002 вище, ніж зображення без підтримки TTA. Неозброєним оком цю різницю важко помітити.

### Що таке "додаткова обробка для GIF з прозорістю"?

GIF-файли підтримують лише палітру до 256 кольорів RGB і встановлюють один з них прозорим (необов'язково), що означає відсутність напівпрозорості. Для GIF-файлів з прозорими частинами це створює дві проблеми.

* Альфа-канал зображення має тільки два значення, 0 і 255, і може бути представлений зображенням тільки з чорно-білими кольорами, з сильними нерівностями.
* Колір прозорої частини на каналі RGB стає непередбачуваним після того, як кожен кадр GIF-файлу буде виділений і збережений у форматі PNG, WebP тощо. Наприклад, колір, встановлений в якості прозорого в GIF спочатку #FFFFFF, але після збереження кадру може стати #000000, хоча це не має ніякого значення, якщо ви просто подивитеся на зображення.

При збільшенні масштабу GIF-зображень за допомогою Real-ESRGAN безпосередньо ([Приклад](https://user-images.githubusercontent.com/47057319/170273973-d9743d66-d6df-42c2-8fe8-b123fa6edb98.gif)), вплив двох вищевказаних проблем є:

* Якість збільшеного альфа-каналу дуже низька, що призводить до появи нерівного кільця навколо масштабованого кадру.
* Колір нерівного кільця непередбачуваний, наприклад чорний в деяких випадках і виглядає дуже негарно.

Ця опція була додана для вирішення цих проблем. Вона додає наступні дії:

* Примусити колір прозорої частини бути білим при розбитті кожного кадру GIF-файлу.
* Додайте розмиття за Гаусом 3px і застосуйте криву контрастності, щоб згладити зазубрені кільця в альфа-каналі. Потім розмийте альфа-канал до чорно-білого зображення зі значеннями 0 і 255.

Ця опція є експериментальною і рекомендується включати її тільки при масштабуванні GIF-файлів з прозорістю.

### Про стиснення з втратами і якість стиснення

Якщо увімкнено стиснення з втратами і вихідним форматом є JPEG або WebP, ви можете керувати якістю стиснення вихідного зображення до заданого значення. Якщо на вході є каталог, на якість стиснення на виході також буде впливати ця опція при збільшенні масштабу зображень JPEG або WebP в каталозі.

Якщо ця опція не включена, то при виведенні у форматі WebP використовується стиснення без втрат.

### Де зберігається файл конфігурації?

Файл `config.ini` в каталозі репозиторію або в каталозі, де знаходиться виконуваний файл Real-ESRGAN GUI, без цього файлу використовується конфігурація за замовчуванням.

Конфігурація буде збережена автоматично при виході з програми.

## Використані бібліотеки з відкритим вихідним кодом

* [Pillow](https://github.com/python-pillow/Pillow)
* [Real-ESRGAN](https://github.com/xinntao/Real-ESRGAN)
* [Sun-Valley-ttk-theme](https://github.com/rdbende/Sun-Valley-ttk-theme)
* [TkInterDnD2](https://github.com/pmgagne/tkinterdnd2)
* [darkdetect](https://github.com/albertosottile/darkdetect)
* [pyinstaller](https://github.com/pyinstaller/pyinstaller)

## Вклади

* Дякую [@blacklein](https://github.com/blacklein) [@hyrulelinks](https://github.com/hyrulelinks) за надання допомоги у використанні та встановленні цього додатку на macOS.
