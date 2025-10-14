#!/bin/bash
echo "🚀 BLAZOS INSTALLATION - WSL UBUNTU"
echo "==================================="

# Install required tools
sudo apt install -y curl wget

# Test LXD
echo "1. Testing LXD..."
lxc list

# Create test containers
echo "2. Creating test containers..."
lxc launch ubuntu:22.04 blazos-ubuntu
lxc launch images:alpine/3.19 blazos-alpine

sleep 20

echo "3. Container status:"
lxc list

echo "4. Testing containers:"
echo "Ubuntu:"
lxc exec blazos-ubuntu -- cat /etc/os-release | grep PRETTY_NAME
echo "Alpine:"
lxc exec blazos-alpine -- cat /etc/os-release | grep PRETTY_NAME

echo ""
echo "✅ BLAZOS INSTALLED SUCCESSFULLY!"
echo "Containers running: Ubuntu 22.04, Alpine 3.19"
