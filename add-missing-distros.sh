#!/bin/bash
echo "🚀 ADDING MISSING DISTRIBUTIONS TO REACH 20"
echo "==========================================="

# Missing distributions to complete the 20
missing_distros=(
    "images:ubuntu/20.04:ubuntu-20"           # Ubuntu 20.04 LTS
    "images:debian/11:debian-11"              # Debian 11 (Bullseye)
    "images:fedora/40:fedora-40"              # Fedora 40
    "images:fedora/41:fedora-41"              # Fedora 41
    "images:archlinux:arch"                   # Arch Linux
    "images:manjaro/stable:manjaro"           # Manjaro
    "images:opensuse/leap/15.6:opensuse-leap" # openSUSE Leap
    "images:opensuse/tumbleweed:opensuse-tumbleweed" # openSUSE Tumbleweed
    "images:kali/rolling:kali"                # Kali Linux
)

echo "📦 Launching missing distributions..."
for distro_spec in "${missing_distros[@]}"; do
    image=$(echo $distro_spec | cut -d':' -f1-2)
    name="blazos-$(echo $distro_spec | cut -d':' -f3)"
    
    # Skip if already exists
    if lxc list -c n | grep -q "$name"; then
        echo "✅ $name already exists"
    else
        echo "🚀 Launching: $image as $name"
        lxc launch "$image" "$name" 2>/dev/null && echo "   ✅ Success" || echo "   ❌ Failed - trying alternative"
        
        # Try alternative if first attempt fails
        if [ $? -ne 0 ]; then
            # Try different image formats
            alt_image=$(echo $image | sed 's/images://')
            echo "   🔄 Trying alternative: $alt_image"
            lxc launch "$alt_image" "$name" 2>/dev/null && echo "   ✅ Alternative success" || echo "   ❌ Alternative failed"
        fi
    fi
done

echo ""
echo "⏳ Waiting for containers to start..."
sleep 40

echo ""
echo "📊 ALL BLAZOS CONTAINERS:"
lxc list | grep "blazos-"

echo ""
echo "🎯 ATTEMPTED TO ADD 9 MORE DISTRIBUTIONS!"
