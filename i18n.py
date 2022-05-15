import configparser
import define
import locale
import os

translation: dict[str, configparser.SectionProxy] = {}
translationRaw = configparser.ConfigParser()
translationRaw.read(os.path.join(define.BASE_PATH, 'i18n.ini'), 'utf-8')
for section in translationRaw:
    for lang in section.split(','):
        translation[lang.strip()] = translationRaw[section]
translation['DEFAULT'].update(translation['en_US'])

def getTranslatedString(key: str) -> str:
    lang = locale.getdefaultlocale()[0]
    try:
        return translation[lang if lang in translation else 'DEFAULT'][key]
    except KeyError:
        return f'{key}${lang}'
