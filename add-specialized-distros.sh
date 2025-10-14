#!/bin/bash
echo "🚀 ADDING SPECIALIZED DISTRIBUTIONS"
echo "==================================="

# Specialized distributions
specialized_distros=(
    "images:voidlinux/current:void"           # Void Linux
    "images:proxmox/8:proxmox"                # Proxmox
    "images:truenas/scale:truenas"            # TrueNAS Scale
)

echo "📦 Launching specialized distributions..."
for distro_spec in "${specialized_distros[@]}"; do
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

# Voyager Linux might need special handling as it's less common
echo ""
echo "🔍 Voyager Linux requires special handling..."
echo "🔄 Trying Voyager from Ubuntu base..."
lxc launch ubuntu:22.04 blazos-voyager 2>/dev/null && echo "✅ Voyager base created" || echo "❌ Voyager failed"

echo ""
echo "⏳ Waiting for containers to start..."
sleep 30

echo ""
echo "📊 ALL BLAZOS CONTAINERS:"
lxc list | grep "blazos-"

echo ""
echo "🎯 SPECIALIZED DISTRIBUTIONS ADDED!"
