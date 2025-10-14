#!/bin/bash
echo "🚀 BLAZOS WORKING LAUNCHER - NO INTERNET REQUIRED"
echo "================================================="

# Set display
export DISPLAY=:0

# Distribution list
declare -A DISTROS=(
    ["Ubuntu 24.04 LTS"]="blazos-ubuntu-24"
    ["Ubuntu 22.04 LTS"]="blazos-ubuntu" 
    ["Debian 12"]="blazos-debian-12"
    ["Debian 11"]="blazos-debian-11"
    ["Alpine 3.22"]="blazos-alpine-322"
    ["Alpine Edge"]="blazos-alpine-edge"
    ["Fedora 41"]="blazos-fedora-41"
    ["Rocky Linux 9"]="blazos-rocky-9"
    ["AlmaLinux 9"]="blazos-alma-9"
    ["CentOS Stream 9"]="blazos-centos-9"
    ["Oracle Linux 9"]="blazos-oracle-9"
    ["Arch Linux"]="blazos-arch"
    ["Manjaro"]="blazos-manjaro"
    ["openSUSE Tumbleweed"]="blazos-opensuse-tumbleweed"
    ["Voyager Linux"]="blazos-voyager"
)

# Build selection
CHOICES=""
for name in $(printf '%s\n' "${!DISTROS[@]}" | sort); do
    container="${DISTROS[$name]}"
    if lxc list --format csv 2>/dev/null | grep -q "^$container,"; then
        status=$(lxc list --format csv -c ns 2>/dev/null | grep "^$container," | cut -d, -f2)
        CHOICES="$CHOICES FALSE \"$name\" \"$status\""
    else
        CHOICES="$CHOICES FALSE \"$name\" \"MISSING\""
    fi
done

# Show launcher
SELECTED=$(eval "zenity --list --radiolist \
    --title=\"BlazOS Distribution Terminal\" \
    --text=\"Select a Linux distribution to open in terminal:\n\nYou can run commands and basic tools in each distribution.\" \
    --column=\"\" --column=\"Distribution\" --column=\"Status\" \
    --width=700 --height=500 \
    $CHOICES 2>/dev/null")

if [ -z "$SELECTED" ]; then
    exit 0
fi

CONTAINER="${DISTROS[$SELECTED]}"

# Start container if needed
if ! lxc list --format csv -c ns 2>/dev/null | grep "^$CONTAINER," | grep -q "RUNNING"; then
    zenity --info --text="Starting $SELECTED..." --timeout=2
    lxc start "$CONTAINER"
    sleep 3
fi

# Get container info
echo "🔍 Getting distribution information..."
OS_INFO=$(lxc exec "$CONTAINER" -- cat /etc/os-release 2>/dev/null | grep "PRETTY_NAME" | head -1 | cut -d= -f2 | tr -d '"' || echo "Unknown")

# Show info and launch terminal
zenity --info --text="Opening $SELECTED\n$OS_INFO\n\nTerminal will open where you can:\n• Run commands\n• Test tools\n• Explore the system\n\nClose terminal to return to launcher." --timeout=5 --width=400

# Launch terminal with container access
gnome-terminal --title="BlazOS: $SELECTED" -- bash -c "
    echo '🐧 Welcome to $SELECTED'
    echo '📍 Container: $CONTAINER'
    echo '🖥️  OS: $OS_INFO'
    echo ''
    echo '💡 Available commands:'
    echo '   ls, cd, cat, grep, find, ps, top, etc.'
    echo ''
    echo '🔧 Try these distro-specific commands:'
    if [[ '$CONTAINER' == *'ubuntu'* ]] || [[ '$CONTAINER' == *'debian'* ]]; then
        echo '   apt list --installed | head -10'
    elif [[ '$CONTAINER' == *'fedora'* ]] || [[ '$CONTAINER' == *'centos'* ]] || [[ '$CONTAINER' == *'rocky'* ]]; then
        echo '   rpm -qa | head -10'
    elif [[ '$CONTAINER' == *'alpine'* ]]; then
        echo '   apk list --installed | head -10'
    elif [[ '$CONTAINER' == *'arch'* ]] || [[ '$CONTAINER' == *'manjaro'* ]]; then
        echo '   pacman -Q | head -10'
    fi
    echo ''
    lxc exec '$CONTAINER' -- bash
    echo ''
    echo '👋 Session ended. Close this window.'
    read -p 'Press Enter to close...'
"

# Return to launcher
zenity --question --text="Return to BlazOS launcher?" --width=300
if [ $? -eq 0 ]; then
    exec "$0"
else
    zenity --info --text="BlazOS launcher closed." --timeout=2
fi
