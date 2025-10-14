#!/bin/bash
# Create all 20 containers

echo "Creating GUI profile..."
lxc profile create gui 2>/dev/null || true

cat << 'EOFPROFILE' | lxc profile edit gui
config:
  limits.cpu: "2"
  limits.memory: 4GB
  environment.DISPLAY: :0
  raw.idmap: both 1000 1000
  security.nesting: "true"
devices:
  X0:
    path: /tmp/.X11-unix/X0
    source: /tmp/.X11-unix/X0
    type: disk
  mygpu:
    type: gpu
EOFPROFILE

echo "Launching containers..."
echo "This may take 5-10 minutes..."

# Function to launch container with error handling
launch_container() {
    local name=$1
    local image=$2
    echo "Launching $name..."
    if ! lxc launch "$image" "$name" -p default -p gui 2>/dev/null; then
        echo "⚠️  Failed to launch $name, trying alternative..."
        # Try with simpler launch
        lxc launch "ubuntu:22.04" "$name" -p default -p gui || echo "❌ Failed to launch $name"
    fi
}

# Launch containers with better error handling
launch_container "ubuntu2204-gui" "ubuntu:22.04"
launch_container "ubuntu2404-gui" "ubuntu:24.04" 
launch_container "debian12-gui" "debian/12"
launch_container "debian11-gui" "debian/11"
launch_container "fedora40-gui" "fedora/40"
launch_container "fedora41-gui" "fedora/41"
launch_container "arch-gui" "archlinux"
launch_container "manjaro-gui" "manjaro/stable"
launch_container "opensuse-leap-gui" "opensuse/15.6"
launch_container "opensuse-tumble-gui" "opensuse/tumbleweed"
launch_container "kali-gui" "kali/rolling"
launch_container "alpine319-gui" "alpine/3.19"
launch_container "alpine-edge-gui" "alpine/edge"
launch_container "rocky-gui" "rockylinux/9"
launch_container "alma-gui" "almalinux/9"
launch_container "centos-gui" "centos/9-Stream"
launch_container "oracle-gui" "oracle/9"
launch_container "gentoo-gui" "gentoo/current"
launch_container "void-gui" "voidlinux/current"
launch_container "devuan-gui" "devuan/chimaera"

echo ""
echo "✅ Container creation completed!"
echo ""
echo "Container status:"
lxc list
