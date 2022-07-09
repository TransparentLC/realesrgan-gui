import os

a = Analysis(
    ['main.py'],
    datas=[
        ('theme', 'theme'),
        ('i18n.ini', '.'),
        ('icon-256px.ico', '.'),
        ('icon-128px.webp', '.'),
    ],
    hiddenimports=[
        'PIL._tkinter_finder',
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
        '_multiprocessing',
        '_overlapped',
        '_queue',
        '_ssl',
        'pyexpat',
        'unicodedata',
    ],
)

a.binaries = [
    x
    for x in a.binaries
    if not any(x[0].startswith(y) for y in(
        'api-ms-win-',
        'ucrtbase.dll',
    ))
]

a.datas = [
    x
    for x in a.datas
    if not any(x[0].startswith(y) for y in(
        os.path.join('tcl', 'encoding'),
        os.path.join('tcl', 'http'),
        os.path.join('tcl', 'msgs'),
        os.path.join('tcl', 'opt'),
        os.path.join('tcl', 'tzdata'),
        os.path.join('tcl8'),
        os.path.join('tk', 'images'),
        os.path.join('tk', 'msgs'),
    ))
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