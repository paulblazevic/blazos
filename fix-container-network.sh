#!/bin/bash
echo "🔧 FIXING CONTAINER NETWORK ACCESS"
echo "=================================="

# Check host network
echo "1. Checking host network..."
ping -c 2 google.com

# Check container network
echo ""
echo "2. Testing container network access..."
lxc exec blazos-ubuntu-24 -- ping -c 2 google.com || echo "   ❌ Container has no internet"

# Fix LXD network configuration
echo ""
echo "3. Checking LXD network configuration..."
lxc network show lxdbr0

echo ""
echo "🔧 If containers have no internet, try:"
echo "   sudo systemctl restart lxd"
echo "   lxc restart --all"
