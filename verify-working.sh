#!/bin/bash
echo "🔍 VERIFYING WORKING BLAZOS DISTRIBUTIONS"
echo "========================================="

echo "🐧 CURRENT BLAZOS SYSTEM:"
containers=$(lxc list -c n | grep "blazos-" | awk '{print $2}')

for container in $containers; do
    distro_name=$(echo $container | sed 's/blazos-//')
    state=$(lxc list $container --format csv | cut -d, -f2)
    ip=$(lxc list $container --format csv | cut -d, -f4)
    
    if [ "$state" = "RUNNING" ]; then
        # Get OS info based on distro type
        if [[ $container == *"ubuntu"* ]] || [[ $container == *"debian"* ]]; then
            os_info=$(lxc exec $container -- lsb_release -d 2>/dev/null | cut -f2 || echo "Unknown")
        elif [[ $container == *"alpine"* ]]; then
            os_info=$(lxc exec $container -- cat /etc/alpine-release 2>/dev/null || echo "Alpine Linux")
        else
            os_info=$(lxc exec $container -- cat /etc/os-release 2>/dev/null | grep "PRETTY_NAME" | head -1 | cut -d= -f2 | tr -d '"' || echo "Unknown")
        fi
        echo "   ✅ $distro_name: $os_info"
        echo "      IP: $ip | Access: lxc exec $container -- bash"
    else
        echo "   ⚠️  $distro_name: $state"
    fi
    echo ""
done

total=$(echo "$containers" | wc -w)
echo "🎯 TOTAL WORKING DISTRIBUTIONS: $total"
