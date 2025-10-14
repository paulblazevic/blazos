#!/bin/bash
echo "📦 BLAZOS PACKAGE MANAGER COMPARISON"
echo "==================================="

echo "🔍 Comparing package managers across distributions..." > /tmp/blazos-pkgs.txt
echo "===================================================" >> /tmp/blazos-pkgs.txt
echo "" >> /tmp/blazos-pkgs.txt

# Ubuntu/Debian (APT)
echo "🐧 Ubuntu/Debian (APT):" >> /tmp/blazos-pkgs.txt
lxc exec blazos-ubuntu-24 -- bash -c "which apt && echo 'Installed packages:' && apt list --installed 2>/dev/null | wc -l || echo 'APT not available'" >> /tmp/blazos-pkgs.txt 2>/dev/null
echo "" >> /tmp/blazos-pkgs.txt

# Fedora/RHEL (DNF/RPM)
echo "🔴 Fedora/RHEL (DNF):" >> /tmp/blazos-pkgs.txt
lxc exec blazos-fedora-41 -- bash -c "which dnf && echo 'Installed packages:' && rpm -qa | wc -l || echo 'DNF not available'" >> /tmp/blazos-pkgs.txt 2>/dev/null
echo "" >> /tmp/blazos-pkgs.txt

# Alpine (APK)
echo "🏔️ Alpine (APK):" >> /tmp/blazos-pkgs.txt
lxc exec blazos-alpine-322 -- bash -c "which apk && echo 'Installed packages:' && apk info | wc -l || echo 'APK not available'" >> /tmp/blazos-pkgs.txt 2>/dev/null
echo "" >> /tmp/blazos-pkgs.txt

# Arch (Pacman)
echo "🌀 Arch (Pacman):" >> /tmp/blazos-pkgs.txt
lxc exec blazos-arch -- bash -c "which pacman && echo 'Installed packages:' && pacman -Q | wc -l || echo 'Pacman not available'" >> /tmp/blazos-pkgs.txt 2>/dev/null
echo "" >> /tmp/blazos-pkgs.txt

zenity --text-info --filename=/tmp/blazos-pkgs.txt --title="BlazOS Package Manager Comparison" --width=700 --height=500
