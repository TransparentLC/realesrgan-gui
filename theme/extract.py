import os
import json

with open('sprites.json', 'rb') as f:
    spriteData = json.load(f)

for p in (
    'light-',
    'dark-',
):
    print('variable sprites [image create photo -file [file join [file dirname [info script]] sprites.png] -format png]')
    print()
    print('variable images')
    for f in spriteData['frames']:
        if not f['filename'].startswith(p):
            continue

        print('set images({}) [image create photo -width {} -height {}]'.format(
            os.path.splitext(f['filename'])[0].removeprefix(p),
            f['frame']['w'],
            f['frame']['h'],
        ))
        print('$images({}) copy $sprites -from {} {} {} {}'.format(
            os.path.splitext(f['filename'])[0].removeprefix(p),
            f['frame']['x'],
            f['frame']['y'],
            f['frame']['x'] + f['frame']['w'],
            f['frame']['y'] + f['frame']['h'],
        ))
    print()
    print('unset sprites')
    print()