#!/bin/bash
echo "🔍 VERIFYING BLAZOS WITH UBUNTU 24.04"
echo "======================================"

echo "1. Ubuntu 24.04:"
echo "   OS: $(lxc exec blazos-ubuntu -- lsb_release -d | cut -f2)"
echo "   Kernel: $(lxc exec blazos-ubuntu -- uname -r)"

echo ""
echo "2. Alpine 3.19:"
echo "   OS: $(lxc exec blazos-alpine -- cat /etc/alpine-release)"
echo "   Kernel: $(lxc exec blazos-alpine -- uname -r)"

echo ""
echo "3. Debian 12:"
echo "   OS: $(lxc exec blazos-debian -- lsb_release -d | cut -f2)"
echo "   Kernel: $(lxc exec blazos-debian -- uname -r)"

echo ""
echo "📊 ALL CONTAINERS:"
lxc list

echo ""
echo "✅ BLAZOS NOW FEATURES:"
echo "   - Ubuntu 24.04 LTS (Latest)"
echo "   - Alpine Linux 3.19 (Lightweight)"
echo "   - Debian 12 (Stable)"
