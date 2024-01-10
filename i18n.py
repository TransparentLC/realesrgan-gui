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

# List all locales without 'DEFAULT'
all_locales = list(translation.keys())[1::]

# Manually copied from babel because
# babel has a huge (30mb) bundled data
locales_map = {
    'English (United Kingdom)': 'en_GB',
    'English (United States)': 'en_US',
    'Türkçe (Türkiye)': 'tr_TR',
    'español (Argentina)': 'es_AR',
    'español (Colombia)': 'es_CO',
    'español (España)': 'es_ES',
    'español (México)': 'es_MX',
    'українська (Україна)': 'uk_UA',
    '中文 (简体, 中国)': 'zh_CN',
    '中文 (简体, 新加坡)': 'zh_SG',
    '中文 (繁體, 台灣)': 'zh_TW',
    '中文 (繁體字, 中國澳門特別行政區)': 'zh_MO',
    '中文 (繁體字, 中國香港特別行政區)': 'zh_HK'
}

current_language = None

def set_current_language(lang_in_conf: str):
    global current_language
    locale_lang = locale.getdefaultlocale()[0]

    if lang_in_conf in all_locales:
        current_language = lang_in_conf
    elif locale_lang in all_locales:
        current_language = locale_lang
    else:
        current_language = "en_US"

def change_current_lang(key: str, var):
    global current_language
    current_language = key

def get_current_locale_display_name() -> str:
    return all_locales.index(current_language)

def getTranslatedString(key: str) -> str:
    lang = locale.getdefaultlocale()[0]
    try:
        return translation[current_language][key]
    except KeyError:
        return f'{key}${lang}'
