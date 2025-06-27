#!/bin/bash

set -e

sudo apt update
sudo apt install -y software-properties-common
sudo apt-add-repository ppa:dotnet/backports -y

sudo apt update
sudo apt install -y \
wget  \
build-essential \
libx11-dev \
libxrandr-dev \
libxinerama-dev \
libxcursor-dev \
libxi-dev \
libboost-iostreams1.74-dev \
libtbb-dev \
libssl-dev \
libzmq3-dev \
libjemalloc-dev \
libblosc-dev \
doxygen \
cmake-curses-gui \
cmake-qt-gui \
dotnet-sdk-9.0 \
libwayland-dev \
wayland-protocols \
pkg-config \
libxkbcommon-dev \
clang

required_version="3.27.7"
binary_path="/usr/local/bin/cmake"

version_compare() {
local req_ver=$1
local inst_ver=$2
if [[ "$(printf "%s\n" "$req_ver" "$inst_ver" | sort -V | head -n 1)" == "$req_ver" ]]; then
return 0
else
return 1
fi
}

installed_version=$(cmake --version | grep -oP "(?<=version )(\d+.\d+.\d+)")

version_compare "$required_version" "$installed_version"

if [[ $? -eq 0 ]]; then
echo "Installed CMake version ($installed_version) is greater than or equal to $required_version. Installation complete."
exit 0
else
echo "Installed CMake version ($installed_version) is less than $required_version. Adding CMake $required_version."
wget https://github.com/Kitware/CMake/releases/download/v3.27.7/cmake-3.27.7-linux-x86_64.tar.gz
tar -xzvf cmake-3.27.7-linux-x86_64.tar.gz
sudo mv cmake-3.27.7-linux-x86_64 /opt/cmake-3.27.7
if [ -e "$binary_path" ]; then
echo -e "\033[36mTo Do: A version of cmake already exists at $binary_path. Cmake $required_version was installed at /opt/cmake.3.27.7. To use, add it to your PATH explicitly using the command: \n \n
export PATH=/opt/cmake.3.27.7/bin:$PATH \n\033[0m"
else
sudo ln -s /opt/cmake-3.27.7/bin/cmake $binary_path
echo "CMake $required_version symlinked to $binary_path from location in /opt."
fi
rm cmake-3.27.7-linux-x86_64.tar.gz
echo "Installation complete."
fi

cd PicoGKRuntime
mkdir build
cd build
cmake ..
make

exit 0


