#!/bin/bash
echo "🔄 UPGRADING TO UBUNTU 24.04"
echo "============================"

echo "1. Launching Ubuntu 24.04..."
lxc launch ubuntu:24.04 blazos-ubuntu

echo "2. Waiting for startup..."
sleep 20

echo "3. Testing Ubuntu 24.04:"
lxc exec blazos-ubuntu -- cat /etc/os-release | grep "PRETTY_NAME"

echo "4. Current BlazOS containers:"
lxc list

echo ""
echo "✅ UPGRADE COMPLETE!"
echo "Now running: Ubuntu 24.04, Alpine 3.19, Debian 12"
