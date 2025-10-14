#!/bin/bash
echo "➕ ADDING MORE LINUX DISTROS"
echo "============================"

echo "1. Adding Debian 12..."
lxc launch images:debian/12 blazos-debian

echo "2. Adding Fedora 40..."
lxc launch images:fedora/40 blazos-fedora

echo "3. Adding Arch Linux..."
lxc launch images:archlinux blazos-arch

sleep 25

echo ""
echo "📊 ALL BLAZOS CONTAINERS:"
lxc list

echo ""
echo "🎯 BLAZOS EXPANDED!"
echo "Now running: Ubuntu, Alpine, Debian, Fedora, Arch"
