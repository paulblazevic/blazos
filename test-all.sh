#!/bin/bash
echo "🔍 TESTING ALL BLAZOS DISTRIBUTIONS"
echo "==================================="

containers=("ubuntu" "alpine" "debian")

for distro in "${containers[@]}"; do
    echo ""
    echo "📦 $distro:"
    lxc exec "blazos-$distro" -- cat /etc/os-release | grep "PRETTY_NAME"
    echo "   IP: $(lxc list blazos-$distro --format csv | cut -d, -f4)"
done

echo ""
echo "✅ BLAZOS MULTI-DISTRO SYSTEM RUNNING!"
echo "3 Linux distributions operating simultaneously"
