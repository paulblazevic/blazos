#!/bin/bash
echo "🚀 BLAZOS MAIN LAUNCHER"
echo "======================"

echo "🖥️ Available launchers:"
echo "1. GUI Launcher"
echo "2. Terminal Launcher" 
echo "3. Check Status"
echo "4. Exit"

read -p "Select option (1-4): " choice

case $choice in
    1)
        ./blazos-gui-launcher.sh
        ;;
    2)
        ./blazos-working-launcher.sh
        ;;
    3)
        echo "📊 DISTRIBUTION STATUS:"
        lxc list | grep blazos
        ;;
    4)
        echo "👋 Goodbye!"
        ;;
    *)
        echo "❌ Invalid option"
        ;;
esac
