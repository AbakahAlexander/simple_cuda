#!/bin/bash

echo "Setting up CUDA development environment..."

# Install CUDA Toolkit (includes nvcc)
if ! command -v nvcc &> /dev/null; then
    echo "Installing CUDA Toolkit..."
    sudo apt update
    sudo apt install -y nvidia-cuda-toolkit
    echo "CUDA Toolkit installed: $(nvcc --version)"
else
    echo "CUDA Toolkit already installed: $(nvcc --version)"
fi

# Install OpenCV development files
if ! pkg-config --exists opencv4 || ! pkg-config --exists opencv; then
    echo "Installing OpenCV development files..."
    sudo apt update
    sudo apt install -y libopencv-dev
    echo "OpenCV installed: $(pkg-config --modversion opencv4 2>/dev/null || pkg-config --modversion opencv 2>/dev/null)"
else
    echo "OpenCV already installed: $(pkg-config --modversion opencv4 2>/dev/null || pkg-config --modversion opencv 2>/dev/null)"
fi

# Check installed components
echo -e "\nEnvironment check:"
echo "CUDA toolkit: $(nvcc --version | head -n1)"
echo "OpenCV: $(pkg-config --modversion opencv4 2>/dev/null || pkg-config --modversion opencv 2>/dev/null || echo 'Not found')"
echo "GPU devices:"
nvidia-smi --query-gpu=name,driver_version --format=csv,noheader 2>/dev/null || echo "No NVIDIA GPU or driver detected"

echo -e "\nSetup complete. You can now run 'make clean build'"
