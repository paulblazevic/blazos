#!/bin/bash
echo "🚀 ADDING WORKING BLAZOS DISTRIBUTIONS"
echo "======================================"

# List of distributions with WORKING versions
distros=(
    "ubuntu:24.04:ubuntu-24"
    "images:debian/12:debian-12"
    "images:alpine/3.22:alpine-322"
    "images:alpine/edge:alpine-edge"
    "images:rockylinux/9:rocky-9"
    "images:almalinux/9:alma-9"
    "images:centos/9-Stream:centos-9"
    "images:oracle/9:oracle-9"
)

echo "📦 Launching working distributions..."
for distro_spec in "${distros[@]}"; do
    if [[ $distro_spec == ubuntu:* ]]; then
        image=$(echo $distro_spec | cut -d':' -f1-2)
        name="blazos-$(echo $distro_spec | cut -d':' -f3)"
    else
        image=$(echo $distro_spec | cut -d':' -f1-2)
        name="blazos-$(echo $distro_spec | cut -d':' -f3)"
    fi
    
    # Skip if already exists
    if lxc list -c n | grep -q "$name"; then
        echo "✅ $name already exists"
    else
        echo "🚀 Launching: $image as $name"
        lxc launch "$image" "$name" 2>/dev/null && echo "   ✅ Success" || echo "   ❌ Failed"
    fi
done

echo ""
echo "⏳ Waiting for containers to start..."
sleep 30

echo ""
echo "📊 ALL BLAZOS CONTAINERS:"
lxc list

echo ""
echo "🎯 WORKING DISTRIBUTIONS LAUNCHED!"
