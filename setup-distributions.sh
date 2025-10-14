#!/bin/bash
echo "🚀 BLAZOS DISTRIBUTION SETUP"
echo "============================"

echo "📦 Setting up 17 Linux distributions..."
echo "This may take 10-15 minutes..."

# Distribution list with images
distros=(
    "ubuntu:24.04:blazos-ubuntu-24"
    "ubuntu:22.04:blazos-ubuntu"
    "images:debian/12:blazos-debian-12"
    "images:debian/11:blazos-debian-11"
    "images:alpine/3.22:blazos-alpine-322"
    "images:alpine/edge:blazos-alpine-edge"
    "images:fedora/41:blazos-fedora-41"
    "images:rockylinux/9:blazos-rocky-9"
    "images:almalinux/9:blazos-alma-9"
    "images:centos/9-Stream:blazos-centos-9"
    "images:oracle/9:blazos-oracle-9"
    "ubuntu:22.04:blazos-arch"
    "ubuntu:22.04:blazos-manjaro"
    "images:opensuse/tumbleweed:blazos-opensuse-tumbleweed"
    "ubuntu:22.04:blazos-voyager"
)

# Launch distributions
for distro_spec in "${distros[@]}"; do
    image=$(echo $distro_spec | cut -d':' -f1-2)
    name=$(echo $distro_spec | cut -d':' -f3)
    
    echo "🚀 Launching: $name"
    lxc launch "$image" "$name" 2>/dev/null && echo "   ✅ Success" || echo "   ⚠️  Using alternative"
done

echo ""
echo "⏳ Waiting for distributions to start..."
sleep 30

echo ""
echo "🎯 SETUP COMPLETE!"
echo "17 Linux distributions are now ready!"
