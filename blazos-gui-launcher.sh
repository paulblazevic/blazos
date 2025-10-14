#!/bin/bash
# BlazOS GUI Distribution Launcher

# Array of all distributions with their display names
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

# Build zenity list
CHOICES=""
for name in $(printf '%s\n' "${!DISTROS[@]}" | sort); do
    container="${DISTROS[$name]}"
    if lxc list --format csv 2>/dev/null | grep -q "^$container,"; then
        status=$(lxc list --format csv -c ns 2>/dev/null | grep "^$container," | cut -d, -f2)
        CHOICES="$CHOICES FALSE \"$name\" \"$status\""
    else
        CHOICES="$CHOICES FALSE \"$name\" \"NOT FOUND\""
    fi
done

# Show launcher GUI
SELECTED=$(eval "zenity --list --radiolist \
    --title=\"BlazOS - Distribution Launcher\" \
    --text=\"Select a Linux distribution to launch in GUI:\" \
    --column=\"\" --column=\"Distribution\" --column=\"Status\" \
    --width=700 --height=600 \
    $CHOICES 2>/dev/null")

if [ -z "$SELECTED" ]; then
    exit 0
fi

CONTAINER="${DISTROS[$SELECTED]}"

# Start container if not running
if ! lxc list --format csv -c ns 2>/dev/null | grep "^$CONTAINER," | grep -q "RUNNING"; then
    zenity --info --text="Starting $SELECTED..." --timeout=2 --width=300
    lxc start "$CONTAINER"
    sleep 5
fi

# Launch XFCE desktop
zenity --info --text="Launching $SELECTED desktop...\\n\\nClose the window to return to launcher." --timeout=3 --width=400

# Launch XFCE in background
lxc exec "$CONTAINER" -- sudo -u guiuser DISPLAY=:0 startxfce4 &

# Wait for user to close
zenity --info --text="$SELECTED is running. Click OK to stop this distribution." --width=400

# Stop the container when done
lxc stop "$CONTAINER"
zenity --info --text="$SELECTED has been stopped. Returning to launcher..." --timeout=2 --width=300

# Restart launcher
exec "$0"
