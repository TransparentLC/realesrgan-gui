# Clone repo
echo "INFO: Clone repo."
git clone https://github.com/TransparentLC/realesrgan-gui.git
cd realesrgan-gui

# Create and activate Python virtual environment
echo "INFO: 🚀 Checking current Python version..."
python_version=$(python3 -V 2>&1 | cut -d" " -f2 | cut -d"." -f1-2)

if ! which python3 >/dev/null 2>&1; then
    echo "ERROR: ⛔️ The 'python3' command not found."
    echo "ERROR: 💬 Please check the Python environment configuration."
    exit 1
else
    echo "INFO: The 'python3' command found." 
    if [ "$python_version" == "3.12" ]; then
        echo "INFO: ✅ The current Python version is 3.12"
        echo "INFO: 🚀 Creating Python 3.12 virtual enviroment..."
        python3 -m venv venv
        echo "INFO: 🚀 Activating Python virtual enviroment..."
        source venv/bin/activate

    else
        echo "ERROR: ⛔️ The current Python version is $python_version but 3.12 is required."
        echo "INFO: 🚀 Installling Python package 'virtualenv'..."
        pip3 install virtualenv
        echo "INFO: 🚀 Creating Python 3.12 virtual enviroment..."
        virtualenv -p python3.12 venv
        echo "INFO: 🚀 Activating Python virtual enviroment..."
        source venv/bin/activate
    fi
fi

# Download required files
echo "INFO: 🚀 Downloading realesrgan-ncnn-vulkan executable and models..."
base_url="https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0"
source_file="realesrgan-ncnn-vulkan-20220424-macos.zip"
target_file="realesrgan-ncnn-vulkan"
model_folder="models"

if command -v wget &> /dev/null; then
    echo "INFO: Using wget..."
        wget -q --show-progress "$base_url/$source_file" -O "$source_file"
else
    echo "INFO: wget not available, using curl..."
    curl -L "$base_url/$source_file" -o "$source_file"
fi

unzip -j "$source_file" "$target_file" -d "."
unzip -j "$source_file" "$model_folder/*" -d "$model_folder"
rm -rf "$source_file"

# Thin fat files to single architecture
arch=$(uname -m)

echo "INFO: System architecture is $arch."
echo "INFO: Extracting architecture specific libraries..."

if [ "$arch" = "arm64" ]; then
  ditto --arch arm64 "$target_file" "temp_file"
else
  ditto --arch x86_64 "$target_file" "temp_file"
fi

rm -rf "$target_file"
mv "temp_file" "$target_file"
chmod u+x "$target_file"

# Install dependencies
echo "INFO: 🚀 Installing requirements..."
pip3 install -r requirements.txt
echo "INFO: 🚀 Installing Python package 'pyinstaller'..."
pip install pyinstaller

# Build macOS app
echo "INFO: 🚀 Packaging macOS app..."
sudo pyinstaller realesrgan-gui-macos.spec

# Copy built app to Download directory
ditto dist/Real-ESRGAN\ GUI.app $HOME/Downloads/Real-ESRGAN\ GUI.app
echo "INFO: ✅ 'Real-ESRGAN GUI.app' is in Downloads directory."
echo "INFO: 💬 Please manually drag 'Real-ESRGAN GUI.app' to Applications directory to finish install."
