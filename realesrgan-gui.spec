import os
import sys
from PyInstaller.utils.hooks import collect_data_files

a = Analysis(
    ['main.py'],
    datas=[
        ('theme', 'theme'),
        ('i18n.ini', '.'),
        ('icon-256px.ico', '.'),
        ('icon-128px.png', '.'),
        # Windows下在任务栏显示进度条
        *((('TaskbarLib.tlb', '.'),) if sys.platform == 'win32' else ()),
        # macOS下通过app实现通知，打包时需要附带
        *collect_data_files('notifypy'),
    ],
    hiddenimports=[
        'PIL._tkinter_finder'
    ],
    hookspath=[
        'pyi-hooks',
    ],
    excludes=[
        '_asyncio',
        '_bz2',
        '_decimal',
        '_hashlib',
        '_lzma',
        *(['_multiprocessing'] if sys.platform == 'win32' else []),
        '_queue',
        '_ssl',
        'unicodedata',
    ],
)

# Windows 10+已经自带UCRT了，打包时不需要附带
a.binaries = [
    x
    for x in a.binaries
    if not any(x[0].startswith(y) for y in {
        'api-ms-win-',
        'ucrtbase.dll',
    })
]

# tcl/tk相关的没有实际使用的大量小文件，在不使用onefile的情况下打包测试，即使不附带这些文件也后不影响运行
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

print('Binaries:')
for i in a.binaries:
    print(i)

print('Datas:')
for i in a.datas:
    print(i)

pyz = PYZ(a.pure, a.zipped_data)

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
        icon='icon-256px.ico',
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
        icon='icon-256px.ico',
    )
    coll = COLLECT(
        exe,
        a.binaries,
        a.zipfiles,
        a.datas,
        name='realesrgan-gui',
        strip=False,
        upx=True,
    )