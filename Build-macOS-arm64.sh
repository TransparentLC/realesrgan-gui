# Step 1
## Download and extract arm64 version from 'realesrgan-ncnn-vulkan'
curl -L "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-macos.zip" -o realesrgan-ncnn-vulkan-20220424-macos.zip
unzip -o realesrgan-ncnn-vulkan-20220424-macos.zip
rm -f realesrgan-ncnn-vulkan-20220424-macos.zip input.jpg input2.jpg onepiece_demo.mp4
lipo realesrgan-ncnn-vulkan -extract arm64 -output realesrgan-ncnn-vulkan-arm64
rm -f realesrgan-ncnn-vulkan
mv realesrgan-ncnn-vulkan-arm64 realesrgan-ncnn-vulkan
chmod u+x realesrgan-ncnn-vulkan

# Step 2
## Create and activate virtualenv
python3 -m venv ./realgui
source ./realgui/bin/activate

# Step 3
## Install dependcies
pip3 install -r requirements.txt

# Step 4
## Create macOS App Bundle
sudo pyinstaller realesrgan-gui-macOS-arm64.spec
