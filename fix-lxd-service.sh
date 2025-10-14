#!/bin/bash
echo "🔧 FIXING LXD SERVICE AND NETWORK"
echo "================================"

echo "1. Checking LXD service status..."
sudo snap services | grep lxd

echo ""
echo "2. Restarting LXD services..."
sudo snap restart lxd

echo ""
echo "3. Restarting all containers..."
lxc restart --all

echo ""
echo "4. Waiting for containers to start..."
sleep 10

echo ""
echo "5. Checking container status..."
lxc list

echo ""
echo "6. Testing network connectivity..."
lxc exec blazos-ubuntu-24 -- ping -c 2 8.8.8.8 && echo "✅ Network working" || echo "❌ Network issues"

echo ""
echo "🎯 LXD service should now be running properly"
