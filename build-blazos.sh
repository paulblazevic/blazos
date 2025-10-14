#!/bin/bash
# BlazOS ISO Builder

set -e

echo "🚀 BlazOS ISO Builder Starting..."
echo "This will take 45-90 minutes"

if [ "$EUID" -ne 0 ]; then 
    echo "❌ Please run with sudo"
    exit 1
fi

# Create build directory
WORK_DIR="$PWD/blazos-build"
mkdir -p "$WORK_DIR"
cd "$WORK_DIR"

echo "📥 Step 1: Downloading Ubuntu 25.10 ISO..."
UBUNTU_ISO_URL="https://releases.ubuntu.com/25.10/ubuntu-25.10-desktop-amd64.iso"
if [ ! -f "ubuntu-25.10-desktop-amd64.iso" ]; then
    wget --progress=bar:force "$UBUNTU_ISO_URL"
else
    echo "   ✓ ISO already downloaded"
fi

echo "✅ Build setup complete - ready for full ISO creation"
echo "📍 Build directory: $WORK_DIR"
