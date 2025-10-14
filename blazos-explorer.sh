#!/bin/bash
echo "🔍 BLAZOS DISTRIBUTION EXPLORER"
echo "================================"

export DISPLAY=:0

# Quick actions
ACTION=$(zenity --list --radiolist \
    --title="BlazOS Quick Actions" \
    --text="What would you like to do?" \
    --column="" --column="Action" --column="Description" \
    FALSE "Terminal Access" "Open terminal in any distribution" \
    FALSE "System Info" "Show information about all distributions" \
    FALSE "Package Managers" "Compare package managers across distros" \
    FALSE "File Systems" "Explore different file systems" \
    FALSE "Process List" "See running processes in each distro" \
    --width=600 --height=400)

case "$ACTION" in
    "Terminal Access")
        ./blazos-working-launcher.sh
        ;;
    "System Info")
        echo "📊 BLAZOS SYSTEM INFORMATION" > /tmp/blazos-info.txt
        echo "============================" >> /tmp/blazos-info.txt
        echo "" >> /tmp/blazos-info.txt
        
        for container in $(lxc list -c n | grep "blazos-" | awk '{print $2}'); do
            echo "🐧 $container:" >> /tmp/blazos-info.txt
            lxc exec $container -- uname -a >> /tmp/blazos-info.txt 2>/dev/null
            lxc exec $container -- cat /etc/os-release | grep "PRETTY_NAME" | head -1 >> /tmp/blazos-info.txt 2>/dev/null
            echo "" >> /tmp/blazos-info.txt
        done
        
        zenity --text-info --filename=/tmp/blazos-info.txt --title="BlazOS System Info" --width=800 --height=600
        ;;
    "Package Managers")
        ./blazos-package-compare.sh
        ;;
    "File Systems")
        echo "📁 FILE SYSTEM COMPARISON" > /tmp/blazos-fs.txt
        echo "========================" >> /tmp/blazos-fs.txt
        echo "" >> /tmp/blazos-fs.txt
        
        for container in blazos-ubuntu-24 blazos-fedora-41 blazos-alpine-322 blazos-arch; do
            if lxc list -c n | grep -q "$container"; then
                echo "🔍 $container:" >> /tmp/blazos-fs.txt
                lxc exec $container -- df -h / >> /tmp/blazos-fs.txt 2>/dev/null
                echo "" >> /tmp/blazos-fs.txt
            fi
        done
        
        zenity --text-info --filename=/tmp/blazos-fs.txt --title="BlazOS File Systems" --width=700 --height=500
        ;;
    "Process List")
        echo "🔄 RUNNING PROCESSES" > /tmp/blazos-procs.txt
        echo "===================" >> /tmp/blazos-procs.txt
        echo "" >> /tmp/blazos-procs.txt
        
        for container in $(lxc list -c n | grep "blazos-" | awk '{print $2}'); do
            echo "⚡ $container:" >> /tmp/blazos-procs.txt
            lxc exec $container -- ps aux --sort=-%cpu | head -5 >> /tmp/blazos-procs.txt 2>/dev/null
            echo "" >> /tmp/blazos-procs.txt
        done
        
        zenity --text-info --filename=/tmp/blazos-procs.txt --title="BlazOS Process List" --width=800 --height=600
        ;;
esac
