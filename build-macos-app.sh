# Download required files
curl -L "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-macos.zip" -o realesrgan-ncnn-vulkan-20220424-macos.zip
unzip -o realesrgan-ncnn-vulkan-20220424-macos.zip
rm -f realesrgan-ncnn-vulkan-20220424-macos.zip input.jpg input2.jpg onepiece_demo.mp4

# Thin fat files to specified architecture
cpu=$(sysctl -n machdep.cpu.brand_string)
if [[ $cpu == *"Intel"* ]]; then
  echo "Intel chip"
  ditto realesrgan-ncnn-vulkan realesrgan-ncnn-vulkan-x64 --arch x86_64
  rm -f realesrgan-ncnn-vulkan
  mv realesrgan-ncnn-vulkan-x64 realesrgan-ncnn-vulkan
  chmod u+x realesrgan-ncnn-vulkan
elif [[ $cpu == *"Apple"* ]]; then
  echo "Apple Silicon"
  ditto realesrgan-ncnn-vulkan realesrgan-ncnn-vulkan-arm64 --arch arm64
  rm -f realesrgan-ncnn-vulkan
  mv realesrgan-ncnn-vulkan-arm64 realesrgan-ncnn-vulkan
  chmod u+x realesrgan-ncnn-vulkan
fi

# Create and activate Python virtualenv
python3 -m venv 'venv'
source 'venv/bin/activate'

# Install dependencies
pip3 install -r requirements.txt
pip3 install pyinstaller==5.*

# Build macOS app
sudo pyinstaller realesrgan-gui-macos.spec
