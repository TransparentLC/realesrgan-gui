import os
import sys

if sys.platform != 'darwin':
	BASE_PATH: str = os.path.realpath(sys._MEIPASS if hasattr(sys, '_MEIPASS') else '')
	APP_PATH = os.path.dirname(os.path.realpath(sys.executable if hasattr(sys, '_MEIPASS') else __file__))
else:
	BASE_PATH = os.path.dirname(os.path.realpath(__file__))
	APP_PATH = BASE_PATH

for executableName in (
	'upscayl-bin',
	'realesrgan-ncnn-vulkan',
	'realcugan-ncnn-vulkan',
):
	if os.path.exists(RE_PATH := os.path.join(APP_PATH, executableName + ('.exe' if os.name == 'nt' else ''))):
		break
APP_TITLE = 'Real-ESRGAN GUI'
APP_CONFIG_PATH = os.path.join(APP_PATH, 'config.ini')
BUILD_TIME: int = None
