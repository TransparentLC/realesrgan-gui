# 导入模块
import os
import sys
from PyInstaller.utils.hooks import collect_data_files
import subprocess

# 获取提交哈希和构造版本号
commit_hash = subprocess.check_output(['git', 'rev-parse', '--short', 'HEAD']).decode('utf-8').strip()
version = "0.2.5." + commit_hash

# PyInstaller分析脚本
# 指定主入口文件
a = Analysis(
    ['main.py'],
    # 需要打包的二进制
    binaries=[
        ('realesrgan-ncnn-vulkan', '.'),
    ],
    # 需要打包的数据文件
    datas=[
        ('models', 'models'),
        ('theme', 'theme'),
        ('i18n.ini', '.'),
        ('icon.icns', '.'),
        ('icon-128px.png', '.'),
    ],
    # 隐藏导入
    hiddenimports=[
        'PIL._tkinter_finder',
    ],
    # PyInstaller钩子目录
    hookspath=[
        'pyi-hooks',
    ],
    # 排除不需要的模块
    excludes=[
        '_asyncio',
        '_bz2',
        '_decimal',
        '_hashlib',
        '_lzma',
        '_queue',
        '_ssl',
        'unicodedata',
    ],
)

# 从binaries中排除不需要的系统dll
# Windows 10+已经自带UCRT，无需打包
a.binaries = [
    x
    for x in a.binaries
    if not any(x[0].startswith(y) for y in {
        'api-ms-win-',
        'ucrtbase.dll',
    })
]

# 从datas中排除不需要的tcl/tk文件，经测试这些文件实际上没有用到
a.datas = [
    x
    for x in a.datas
    if not any(x[0].startswith(y) for y in {
        os.path.join('tcl', 'encoding'),
        os.path.join('tcl', 'http'),
        os.path.join('tcl', 'msgs'),
        os.path.join('tcl', 'opt'),
        os.path.join('tcl', 'tzdata'),
        os.path.join('tcl8'),
        os.path.join('tk', 'images'),
        os.path.join('tk', 'msgs'),
    })
]

# 打印binaries和datas的调试信息
print('Binaries:')
for i in a.binaries:
    print(i)

print('Datas:')
for i in a.datas:
    print(i)

# 生成PYZ文件
pyz = PYZ(a.pure, a.zipped_data)

# 构建可执行文件
if os.environ.get('REGUI_ONEFILE'):
    exe = EXE(
        pyz,
        a.scripts,
        a.binaries,
        a.zipfiles,
        a.datas,
        [],
        name='realesrgan-gui',
        debug=False,
        bootloader_ignore_signals=False,
        strip=False,
        upx=True,
        console=False,
        disable_windowed_traceback=False,
        argv_emulation=False,
        icon='icon.icns',
    )
else:
    exe = EXE(
        pyz,
        a.scripts,
        [],
        exclude_binaries=True,
        name='realesrgan-gui',
        debug=False,
        bootloader_ignore_signals=False,
        strip=False,
        upx=True,
        console=False,
        disable_windowed_traceback=False,
        argv_emulation=False,
        icon='icon.icns',
    )

    # 收集所有文件打包
    coll = COLLECT(
        exe,
        a.binaries,
        a.zipfiles,
        a.datas,
        name='realesrgan-gui',
        strip=False,
        upx=True,
    )

    # 生成macOS应用
    app = BUNDLE(
    coll,
    name='Real-ESRGAN GUI.app',
    icon='icon.icns',
    bundle_identifier=None,
    info_plist={
            'CFBundleDisplayName': 'Real-ESRGAN GUI',
            'CFBundleName': 'Real-ESRGAN GUI',
            'CFBundlePackageType': 'APPL',
            'CFBundleSignature': 'RLES',
            'CFBundleShortVersionString': version,
            'CFBundleVersion': version,
            'CFBundleExecutable': 'realesrgan-gui',
            'CFBundleIconFile': 'icon.icns',
            'CFBundleIdentifier': 'dev.transparentlc.regui',
            'CFBundleInfoDictionaryVersion': '6.0',
            'LSApplicationCategoryType': 'public.app-category.graphics-design',
            'LSEnvironment': {'LANG': 'zh_CN.UTF-8'},
            }
    )
