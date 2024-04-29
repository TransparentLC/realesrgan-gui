import enum
import typing
from PIL import Image

class ResizeMode(enum.IntEnum):
    RATIO = enum.auto()
    WIDTH = enum.auto()
    HEIGHT = enum.auto()

class REConfigParams(typing.NamedTuple):
    model: str
    modelFactor: int
    modelDir: str
    resizeMode: ResizeMode
    resizeModeValue: int
    downsample: 'Image._Resample'
    tileSize: int
    gpuID: int
    useTTA: bool
    customCommand: str
