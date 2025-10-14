#!/bin/bash
echo "🎯 ADDING FINAL 5 DISTRIBUTIONS TO REACH 20"
echo "==========================================="

# Final 5 distributions to reach 20
final_distros=(
    "images:archlinux:arch"                   # Arch Linux
    "images:manjaro/stable:manjaro"           # Manjaro
    "images:opensuse/leap/15.6:opensuse-leap" # openSUSE Leap
    "images:kali/rolling:kali"                # Kali Linux
    "images:voidlinux/current:void"           # Void Linux
)

echo "📦 Launching final 5 distributions..."
for distro_spec in "${final_distros[@]}"; do
    image=$(echo $distro_spec | cut -d':' -f1-2)
    name="blazos-$(echo $distro_spec | cut -d':' -f3)"
    
    # Skip if already exists
    if lxc list -c n | grep -q "$name"; then
        echo "✅ $name already exists"
    else
        echo "🚀 Launching: $image as $name"
        lxc launch "$image" "$name" 2>/dev/null && echo "   ✅ Success" || echo "   ❌ Failed"
    fi
done

echo ""
echo "⏳ Waiting for final containers to start..."
sleep 30

echo ""
echo "📊 ALL BLAZOS CONTAINERS (20 TARGET):"
lxc list | grep "blazos-"

echo ""
echo "🎯 FINAL DISTRIBUTIONS ADDED!"
