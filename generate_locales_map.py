# This file is intended for those who will add a new language
# to the i18n.ini file or contribute to the i18n.py file. 
# Translators should run this file after adding a new language
# and replace the locales_map variable in i18n.py with the one 
# printed by the program before submitting a PR. 

# The reason Babel library is not included in the final packaged app
# is that it increases the program's size by approximately 30mb due to locale data.
from babel import Locale

import configparser
import os

import define

LOCALE_INDENT = 4

translation: dict[str, configparser.SectionProxy] = {}
translationRaw = configparser.ConfigParser()
translationRaw.read(os.path.join(define.BASE_PATH, 'i18n.ini'), 'utf-8')
for section in translationRaw:
    for lang in section.split(','):
        translation[lang.strip()] = translationRaw[section]


all_locales = list(translation.keys())[1::]
locales_map = {Locale.parse(key).get_display_name():key for key in all_locales}

locales_map_str = "locales_map = {\n"

for key, val in locales_map.items():
    locales_map_str += f"{' ' * LOCALE_INDENT}'{key}': '{val}'\n"
locales_map_str += "}"

print(locales_map_str)
