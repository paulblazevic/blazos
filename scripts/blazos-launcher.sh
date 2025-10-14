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
