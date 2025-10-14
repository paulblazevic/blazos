#!/bin/bash
#
# BlazOS Automated Setup Script
# One command to create everything!
#
# Usage: bash blazos-auto-setup.sh
#

set -e

clear
cat << "EOF"
╔════════════════════════════════════════════════════════════╗
║                                                            ║
║    ██████╗ ██╗      █████╗ ███████╗ ██████╗ ███████╗     ║
║    ██╔══██╗██║     ██╔══██╗╚══███╔╝██╔═══██╗██╔════╝     ║
║    ██████╔╝██║     ███████║  ███╔╝ ██║   ██║███████╗     ║
║    ██╔══██╗██║     ██╔══██║ ███╔╝  ██║   ██║╚════██║     ║
║    ██████╔╝███████╗██║  ██║███████╗╚██████╔╝███████║     ║
║    ╚═════╝ ╚══════╝╚═╝  ╚═╝╚══════╝ ╚═════╝ ╚══════╝     ║
║                                                            ║
║              Automated Setup & Build System               ║
║                      Version 1.0                          ║
║                                                            ║
╚════════════════════════════════════════════════════════════╝

EOF

echo "🚀 BlazOS Automated Setup"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""
echo "This script will:"
echo "  1. Install required build tools"
echo "  2. Create complete BlazOS project structure"
echo "  3. Generate all scripts automatically"
echo "  4. Optionally build the ISO"
echo ""
echo "Time required: 5-10 minutes (setup)"
echo "               45-90 minutes (ISO build - optional)"
echo ""
read -p "Continue? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Setup cancelled."
    exit 0
fi

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  STEP 1: Installing Build Tools"
echo "════════════════════════════════════════════════════════════"
echo ""

sudo apt-get update
sudo apt-get install -y \
    git \
    squashfs-tools \
    xorriso \
    isolinux \
    syslinux-utils \
    genisoimage \
    debootstrap \
    rsync \
    wget \
    curl \
    zenity

echo ""
echo "✅ Build tools installed!"
echo ""
echo "════════════════════════════════════════════════════════════"
echo "  STEP 2: Creating Project Structure"
echo "════════════════════════════════════════════════════════════"
echo ""

# Create directory structure
mkdir -p ~/blazos/{config,scripts,desktop,docs,.github/workflows}
cd ~/blazos

echo "✅ Directory structure created"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  STEP 3: Generating Configuration Files"
echo "════════════════════════════════════════════════════════════"
echo ""

# Create packages list
cat > config/packages.list << 'EOF'
snapd
lxd
git
curl
wget
vim
htop
neofetch
zenity
EOF

echo "✅ Config files created"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  STEP 4: Creating Setup Scripts"
echo "════════════════════════════════════════════════════════════"
echo ""

# Create LXD setup script
cat > scripts/setup-lxd.sh << 'EOFSETUP'
#!/bin/bash
# Initialize LXD on first run

if lxc list &>/dev/null 2>&1; then
    echo "✅ LXD already initialized"
    exit 0
fi

echo "Initializing LXD..."

cat << 'EOFLXD' | lxd init --preseed
config:
  core.https_address: '[::]:8443'
  images.auto_update_interval: 0
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  name: lxdbr0
  type: bridge
storage_pools:
- config:
    size: 50GB
  name: default
  driver: zfs
profiles:
- name: default
  devices:
    root:
      path: /
      pool: default
      type: disk
EOFLXD

echo "✅ LXD initialized successfully"
EOFSETUP

chmod +x scripts/setup-lxd.sh

# Create container creation script
cat > scripts/create-containers.sh << 'EOFCREATE'
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
EOFCREATE

chmod +x scripts/create-containers.sh

# Create launcher script
cat > scripts/blazos-launcher.sh << 'EOFLAUNCHER'
#!/bin/bash
# BlazOS Distribution Launcher

declare -A DISTROS=(
    ["Ubuntu 22.04 LTS"]="ubuntu2204-gui"
    ["Ubuntu 24.04 LTS"]="ubuntu2404-gui"
    ["Debian 12"]="debian12-gui"
    ["Debian 11"]="debian11-gui"
    ["Fedora 40"]="fedora40-gui"
    ["Fedora 41"]="fedora41-gui"
    ["Arch Linux"]="arch-gui"
    ["Manjaro"]="manjaro-gui"
    ["openSUSE Leap"]="opensuse-leap-gui"
    ["openSUSE Tumbleweed"]="opensuse-tumble-gui"
    ["Kali Linux"]="kali-gui"
    ["Alpine 3.19"]="alpine319-gui"
    ["Alpine Edge"]="alpine-edge-gui"
    ["Rocky Linux 9"]="rocky-gui"
    ["Alma Linux 9"]="alma-gui"
    ["CentOS Stream 9"]="centos-gui"
    ["Oracle Linux 9"]="oracle-gui"
    ["Gentoo"]="gentoo-gui"
    ["Void Linux"]="void-gui"
    ["Devuan"]="devuan-gui"
)

# Check if LXD initialized
if ! lxc list &>/dev/null 2>&1; then
    if zenity --question --text="LXD needs to be initialized.\n\nThis will take a few minutes.\n\nContinue?" --width=400; then
        /opt/blazos/scripts/setup-lxd.sh | zenity --progress --pulsate --auto-close --width=400 --text="Initializing LXD..."
        /opt/blazos/scripts/create-containers.sh | zenity --progress --pulsate --auto-close --width=400 --text="Creating containers..."
    else
        exit 0
    fi
fi

# Build selection list
CHOICES=""
for name in $(printf '%s\n' "${!DISTROS[@]}" | sort); do
    container="${DISTROS[$name]}"
    if lxc list --format csv 2>/dev/null | grep -q "^$container,"; then
        status=$(lxc list --format csv -c ns 2>/dev/null | grep "^$container," | cut -d, -f2)
        CHOICES="$CHOICES FALSE \"$name\" \"$status\""
    else
        CHOICES="$CHOICES FALSE \"$name\" \"NOT CREATED\""
    fi
done

# Show launcher
SELECTED=$(eval "zenity --list --radiolist \
    --title=\"BlazOS - Distribution Launcher\" \
    --text=\"Select a Linux distribution to launch:\" \
    --column=\"\" --column=\"Distribution\" --column=\"Status\" \
    --width=700 --height=800 \
    $CHOICES 2>/dev/null")

if [ -z "$SELECTED" ]; then
    exit 0
fi

CONTAINER="${DISTROS[$SELECTED]}"

# Check container exists
if ! lxc list --format csv 2>/dev/null | grep -q "^$CONTAINER,"; then
    zenity --error --text="Container $CONTAINER does not exist!\n\nPlease run setup first." --width=400
    exit 1
fi

# Start container if needed
if ! lxc list --format csv -c ns 2>/dev/null | grep "^$CONTAINER," | grep -q "RUNNING"; then
    zenity --info --text="Starting $SELECTED..." --timeout=3 --width=400
    lxc start "$CONTAINER"
    sleep 5
fi

# Check if desktop installed
if ! lxc exec "$CONTAINER" -- which startxfce4 >/dev/null 2>&1; then
    if zenity --question --text="Desktop environment not installed in $SELECTED.\n\nInstall now? (Takes 5-10 minutes)" --width=400; then
        # Install XFCE based on distro
        (
        echo "10"; echo "# Updating packages..."
        
        if lxc exec "$CONTAINER" -- which apt-get >/dev/null 2>&1; then
            lxc exec "$CONTAINER" -- apt-get update >/dev/null 2>&1
            echo "50"; echo "# Installing desktop..."
            lxc exec "$CONTAINER" -- bash -c "DEBIAN_FRONTEND=noninteractive apt-get install -y xfce4 xfce4-goodies" >/dev/null 2>&1
        elif lxc exec "$CONTAINER" -- which dnf >/dev/null 2>&1; then
            lxc exec "$CONTAINER" -- dnf check-update >/dev/null 2>&1 || true
            echo "50"; echo "# Installing desktop..."
            lxc exec "$CONTAINER" -- dnf groupinstall -y "Xfce Desktop" >/dev/null 2>&1
        elif lxc exec "$CONTAINER" -- which pacman >/dev/null 2>&1; then
            lxc exec "$CONTAINER" -- pacman -Sy --noconfirm >/dev/null 2>&1
            echo "50"; echo "# Installing desktop..."
            lxc exec "$CONTAINER" -- pacman -S --noconfirm xfce4 xfce4-goodies >/dev/null 2>&1
        elif lxc exec "$CONTAINER" -- which zypper >/dev/null 2>&1; then
            lxc exec "$CONTAINER" -- zypper refresh >/dev/null 2>&1
            echo "50"; echo "# Installing desktop..."
            lxc exec "$CONTAINER" -- zypper install -y -t pattern xfce >/dev/null 2>&1
        elif lxc exec "$CONTAINER" -- which apk >/dev/null 2>&1; then
            lxc exec "$CONTAINER" -- apk update >/dev/null 2>&1
            echo "50"; echo "# Installing desktop..."
            lxc exec "$CONTAINER" -- apk add xfce4 xfce4-terminal >/dev/null 2>&1
        fi
        
        echo "90"; echo "# Creating user..."
        lxc exec "$CONTAINER" -- useradd -m -s /bin/bash distrouser 2>/dev/null || true
        lxc exec "$CONTAINER" -- bash -c "echo 'distrouser:password' | chpasswd" 2>/dev/null
        
        echo "100"; echo "# Complete!"
        ) | zenity --progress --auto-close --width=400 --title="Installing Desktop"
    else
        exit 0
    fi
fi

# Launch desktop
zenity --info --text="Launching $SELECTED desktop...\n\nClose the window to return to the launcher." --timeout=2 --width=400
lxc exec "$CONTAINER" -- sudo -u distrouser DISPLAY=:0 startxfce4 &

exit 0
EOFLAUNCHER

chmod +x scripts/blazos-launcher.sh

echo "✅ Scripts created"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  STEP 5: Creating Desktop Assets"
echo "════════════════════════════════════════════════════════════"
echo ""

# Create a simple icon file
cat > desktop/blazos-icon.svg << 'EOF'
<svg width="64" height="64" xmlns="http://www.w3.org/2000/svg">
  <rect width="64" height="64" fill="#4a86e8" rx="10"/>
  <text x="32" y="40" text-anchor="middle" fill="white" font-family="Arial" font-size="24" font-weight="bold">B</text>
</svg>
EOF

echo "✅ Desktop assets created"

echo ""
echo "════════════════════════════════════════════════════════════"
echo "  STEP 6: Creating Documentation"
echo "════════════════════════════════════════════════════════════"
echo ""

# Create README
cat > README.md << 'EOFREADME'
# BlazOS 🔥

**The Ultimate Multi-Distro Linux Experience**

BlazOS is a live bootable ISO based on Ubuntu 25.10 that lets you run and switch between 20 different Linux distributions using LXD containers.

## ✨ Features

- 🚀 **20 Linux Distros** ready to launch
- 💨 **Instant switching** between distributions  
- 🎨 **Full desktop environments** for each distro
- 💾 **Live USB bootable** - no installation required
- 🔧 **LXD-powered** - lightweight and efficient
- 🖥️ **Optimized for servers** with plenty of RAM

## 📦 Included Distributions

1. Ubuntu 22.04 & 24.04 LTS
2. Debian 11 & 12
3. Fedora 40 & 41
4. Arch Linux & Manjaro
5. openSUSE Leap & Tumbleweed
6. Kali Linux
7. Alpine Linux (Stable & Edge)
8. Rocky Linux 9
9. Alma Linux 9
10. CentOS Stream 9
11. Oracle Linux 9
12. Gentoo
13. Void Linux
14. Devuan

## 💻 System Requirements

### Recommended (Run all 20 distros)
- CPU: 8+ cores
- RAM: 64GB+
- Storage: 200GB+
- Graphics: Dedicated GPU

### Minimum (Run 2-3 distros)
- CPU: Dual-core
- RAM: 8GB
- Storage: 20GB
- Graphics: GPU with OpenGL support

## 🚀 Quick Start

### Download
Download the latest BlazOS ISO from [Releases](https://github.com/paulblazevic/blazos/releases)

### Create Bootable USB
```bash
# Linux
sudo dd if=BlazOS.iso of=/dev/sdX bs=4M status=progress && sync

# Windows - use Rufus or Etcher
