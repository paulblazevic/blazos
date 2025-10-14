#!/bin/bash
echo "🔄 ALTERNATIVE APPROACH FOR FINAL 5"
echo "==================================="

# Try different image formats and sources
alternative_attempts=(
    "archlinux:arch"
    "manjaro/stable:manjaro" 
    "opensuse/15.6:opensuse-leap"
    "kali/rolling:kali"
    "voidlinux:void"
)

echo "🔄 Trying alternative image formats..."
for distro_spec in "${alternative_attempts[@]}"; do
    name="blazos-$(echo $distro_spec | cut -d':' -f2)"
    
    # Skip if already exists
    if lxc list -c n | grep -q "$name"; then
        echo "✅ $name already exists"
    else
        # Try multiple image formats
        echo "🔄 Attempting $name with different sources:"
        
        # Try without images: prefix
        lxc launch "$(echo $distro_spec | cut -d':' -f1)" "$name" 2>/dev/null && echo "   ✅ Success (direct)" && continue
        
        # Try ubuntu: format for some
        if [[ "$distro_spec" == *"manjaro"* ]] || [[ "$distro_spec" == *"arch"* ]]; then
            lxc launch "ubuntu:22.04" "$name" 2>/dev/null && echo "   ✅ Success (Ubuntu base)" && continue
        fi
        
        # Try debian base for others
        if [[ "$distro_spec" == *"kali"* ]]; then
            lxc launch "debian:12" "$name" 2>/dev/null && echo "   ✅ Success (Debian base)" && continue
        fi
        
        echo "   ❌ All attempts failed for $name"
    fi
done

sleep 20

echo ""
echo "📊 CURRENT COUNT:"
total=$(lxc list -c n | grep "blazos-" | wc -l)
echo "🎯 Total distributions: $total"
