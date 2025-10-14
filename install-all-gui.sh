#!/bin/bash
echo "🖥️ INSTALLING GUI (XFCE) ON ALL BLAZOS DISTRIBUTIONS"
echo "===================================================="

# Get all blazos containers
containers=$(lxc list -c n | grep "blazos-" | awk '{print $2}')

for container in $containers; do
    echo ""
    echo "🔧 Installing GUI on: $container"
    
    # Check if container is running
    state=$(lxc list $container --format csv | cut -d, -f2)
    if [ "$state" != "RUNNING" ]; then
        echo "   Starting $container..."
        lxc start $container
        sleep 5
    fi
    
    # Install XFCE based on distro family
    if lxc exec $container -- which apt-get &>/dev/null; then
        echo "   📦 Debian/Ubuntu family - installing XFCE..."
        lxc exec $container -- bash -c "DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y xfce4 xfce4-goodies firefox"
        lxc exec $container -- adduser --disabled-password --gecos '' guiuser
        lxc exec $container -- bash -c "echo 'guiuser:password' | chpasswd"
        
    elif lxc exec $container -- which dnf &>/dev/null; then
        echo "   📦 Fedora/RHEL family - installing XFCE..."
        lxc exec $container -- dnf groupinstall -y "Xfce Desktop"
        lxc exec $container -- dnf install -y firefox
        lxc exec $container -- useradd -m -s /bin/bash guiuser
        lxc exec $container -- bash -c "echo 'guiuser:password' | chpasswd"
        
    elif lxc exec $container -- which apk &>/dev/null; then
        echo "   📦 Alpine family - installing XFCE..."
        lxc exec $container -- apk update
        lxc exec $container -- apk add xfce4 xfce4-terminal firefox
        lxc exec $container -- adduser -D -s /bin/sh guiuser
        lxc exec $container -- echo "guiuser:password" | chpasswd
        
    else
        echo "   ⚠️  Unknown package manager - manual setup required"
    fi
    
    echo "   ✅ GUI setup completed for $container"
done

echo ""
echo "🎉 GUI INSTALLATION COMPLETE!"
echo "All distributions now have XFCE desktop environment"
