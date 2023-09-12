# Clone repo
git clone https://github.com/TransparentLC/realesrgan-gui.git
cd realesrgan-gui

# Download required files
curl -L "https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-macos.zip" -o realesrgan-ncnn-vulkan-20220424-macos.zip
unzip -o realesrgan-ncnn-vulkan-20220424-macos.zip
rm -f realesrgan-ncnn-vulkan-20220424-macos.zip input.jpg input2.jpg onepiece_demo.mp4

# Thin fat files to single architecture
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
python_version=$(python -V 2>&1 | cut -d" " -f2 | cut -d. -f1-2)
if [[ "$python_version" == "3.11" ]]; then
  python3 -m venv 'venv'
  source 'venv/bin/activate'
else
  echo "Current Python version is $python_version, but 3.11 is required."
  if command -v pyenv >/dev/null 2>&1; then
    pyenv install 3.11
    pyenv global 3.11
    exec zsh
  else
    echo "pyenv command is not available"
    echo "Please ensure current Python version is 3.11, then run script again."
  fi
fi

# Install dependencies
pip3 install -r requirements.txt
pip3 install pyinstaller

# Build macOS app
sudo pyinstaller realesrgan-gui-macos.spec

# Copy built app to Download directory
cp dist/Real-ESRGAN\ GUI.app $HOME/Downloads
