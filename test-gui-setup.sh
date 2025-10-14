#!/bin/bash
echo "🧪 TESTING GUI SETUP ON ALL DISTRIBUTIONS"
echo "========================================="

containers=$(lxc list -c n | grep "blazos-" | awk '{print $2}')

echo "🔍 Checking GUI installation status:"
for container in $containers; do
    echo ""
    echo "📦 $container:"
    
    # Check if XFCE is installed
    if lxc exec $container -- which startxfce4 &>/dev/null; then
        echo "   ✅ XFCE installed"
    else
        echo "   ❌ XFCE not found"
    fi
    
    # Check if guiuser exists
    if lxc exec $container -- id guiuser &>/dev/null; then
        echo "   ✅ GUI user created"
    else
        echo "   ❌ GUI user missing"
    fi
done

echo ""
echo "🎯 GUI LAUNCHER READY:"
echo "   Run: ./blazos-gui-launcher.sh"
echo "   Or click desktop shortcut: 'BlazOS Launcher'"
echo ""
echo "🖥️ The launcher will show all 17 distributions"
echo "   Select one → It starts → GUI launches → Use it → Close → Select another"
