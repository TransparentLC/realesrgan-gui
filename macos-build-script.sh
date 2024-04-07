# Clone repo
echo "INFO: Clone repo."
mirror_head="https://mirror.ghproxy.com"
git clone $mirror_head/https://github.com/TransparentLC/realesrgan-gui.git
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

# Download extra files
# Function to download and process release asset
download_asset() {
    repo=$1
    asset_keyword=$2
    unzip_target=$3
    output_folder=$4

    # GitHub API endpoint to retrieve releases
    api_url="https://api.github.com/repos/$repo/releases/latest"

    # Make a GET request to the GitHub API to retrieve the latest release
    response=$(curl -s "$api_url")

    # Check if repo is xinntao/Real-ESRGAN
    if [ "$repo" = "xinntao/Real-ESRGAN" ]; then
        asset_url="https://github.com/xinntao/Real-ESRGAN/releases/download/v0.2.5.0/realesrgan-ncnn-vulkan-20220424-macos.zip"
        zip_file=$(basename "$asset_url")
        folder_name="models"
    else
        # Parse the response to get the latest release asset URL
        asset_url=$(echo "$response" | grep -o "https://.*$asset_keyword*.zip" | head -n 1)
        zip_file=$(basename "$asset_url")
        folder_name=$(basename -s .zip "$zip_file")
    fi

    # Download the latest release asset
    if [ -n "$asset_url" ]; then
        echo "INFO: 🚀 Downloading $zip_file..."
        curl -LO "$mirror_head/$asset_url"
        echo "INFO: ✅ Download $zip_file complete."

        # Unzip and process the file
        echo "INFO: 🚀 Extracting and processing files..."
        unzip -j "$zip_file" "$folder_name/$unzip_target" -d "$output_folder"

        # Perform additional actions based on the repo
        if [ "$repo" = "upscayl/upscayl-ncnn" ]; then
            # Set permissions
            if [ -f "upscayl-bin" ]; then
                # Thin file
                echo "INFO: 🚀 Thin fat files to single architecture..."
                arch=$(uname -m)
                echo "INFO: 💬 System architecture is $arch."
                echo "INFO: 🚀 Extracting architecture specific libraries..."
                if [ "$arch" = "arm64" ]; then
                    ditto --arch arm64 "$target_file" "$target_file_temp"
                else
                    ditto --arch x86_64 "$target_file" "$target_file_temp"
                fi
                rm -rf "$target_file"
                mv "$target_file_temp" "$target_file"
                # Add execute permission
                echo "INFO: 🚀 Add execute permission to realesrgan-ncnn-vulkan..."
                chmod u+x realesrgan-ncnn-vulkan
            fi
        elif [ "$repo" = "nihui/realsr-ncnn-vulkan" ]; then
            # Rename RealSR models
            if [ -f "models/x4.param" ] && [ -f "models/x4.bin" ]; then
                echo "INFO: 🚀 Rename RealSR models..."
                mv models/x4.param models/realsr-x4-realworld.param
                mv models/x4.bin models/realsr-x4-realworld.bin
            fi
        elif [ "$repo" = "xinntao/Real-ESRGAN" ]; then
            # Models to remove
            models_to_remove=(
                "realesr-animevideov3-x2"
                "realesr-animevideov3-x3"
            )
            # Remove models
            for model in "${models_to_remove[@]}"; do
                param_file="models/$model.param"
                bin_file="models/$model.bin"
                if [ -f "$param_file" ] && [ -f "$bin_file" ]; then
                    echo "INFO: 🚀 Removing $model models..."
                    rm -rf "$param_file" "$bin_file"
                fi
            done
        fi
        echo "INFO: ✅ Processing complete."
    else
        echo "ERROR: ⛔️ No release asset found for $repo."
    fi
}

# Download and process assets for upscayl-ncnn
download_asset "upscayl/upscayl-ncnn" "macos" "upscayl-bin" "."

# Download and process assets for realsr-ncnn-vulkan
download_asset "nihui/realsr-ncnn-vulkan" "macos" "models-DF2K/*" "models"

# Download and process assets for realesrgan-ncnn-vulkan
download_asset "xinntao/Real-ESRGAN" "macos" "*" "models"

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
