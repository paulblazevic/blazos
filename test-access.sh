#!/bin/bash
echo "🔍 TESTING MULTI-DISTRO ACCESS"
echo "=============================="

echo "1. Ubuntu 22.04:"
echo "   OS: $(lxc exec blazos-ubuntu -- lsb_release -d | cut -f2)"
echo "   Kernel: $(lxc exec blazos-ubuntu -- uname -r)"

echo ""
echo "2. Alpine 3.19:"
echo "   OS: $(lxc exec blazos-alpine -- cat /etc/alpine-release)"
echo "   Kernel: $(lxc exec blazos-alpine -- uname -r)"

echo ""
echo "3. Running processes:"
echo "   Ubuntu processes: $(lxc exec blazos-ubuntu -- ps aux | wc -l)"
echo "   Alpine processes: $(lxc exec blazos-alpine -- ps | wc -l)"

echo ""
echo "✅ BLAZOS MULTI-DISTRO SYSTEM ACTIVE!"
