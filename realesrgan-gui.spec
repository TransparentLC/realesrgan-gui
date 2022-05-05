# -*- mode: python ; coding: utf-8 -*-

# Created from command:
# pyi-makespec --additional-hooks-dir pyi-hooks --hidden-import PIL._tkinter_finder --exclude-module ... --add-data ... --icon icon-256px.ico --name realesrgan-gui --noconsole --onefile main.py
# Build:
# pyinstaller --clean realesrgan-gui.spec

import os

block_cipher = None

a = Analysis(
    ['main.py'],
    pathex=[],
    binaries=[],
    datas=[
        (os.path.join('theme', 'sprites.png'), 'theme'),
        (os.path.join('theme', 'sun-valley.tcl'), 'theme'),
        ('icon-256px.ico', '.'),
        ('icon-128px.webp', '.'),
    ],
    hiddenimports=[
        'PIL._tkinter_finder',
    ],
    hookspath=[
        'pyi-hooks',
    ],
    hooksconfig={},
    runtime_hooks=[],
    excludes=[
        '_asyncio',
        '_bz2',
        '_ctypes',
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
    win_no_prefer_redirects=False,
    win_private_assemblies=False,
    cipher=block_cipher,
    noarchive=False,
)

print('Binaries:')
for i in a.binaries:
    print(i)

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

pyz = PYZ(a.pure, a.zipped_data, cipher=block_cipher)

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
    upx_exclude=[],
    runtime_tmpdir=None,
    console=False,
    disable_windowed_traceback=False,
    argv_emulation=False,
    target_arch=None,
    codesign_identity=None,
    entitlements_file=None,
    icon='icon-256px.ico',
)