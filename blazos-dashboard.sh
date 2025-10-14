#!/bin/bash
echo "🖥️ BLAZOS MANAGEMENT DASHBOARD"
echo "=============================="

echo "📊 SYSTEM STATUS:"
total=$(lxc list -c n | grep "blazos-" | wc -l)
running=$(lxc list -c ns | grep "blazos-" | grep "RUNNING" | wc -l)
stopped=$(lxc list -c ns | grep "blazos-" | grep "STOPPED" | wc -l)

echo "   Total Distributions: $total"
echo "   Currently Running: $running"
echo "   Stopped: $stopped"

echo ""
echo "🚀 QUICK START:"
echo "   To access any distribution:"
echo "   lxc exec [container-name] -- bash"
echo ""
echo "   Examples:"
echo "   lxc exec blazos-ubuntu-24 -- bash"
echo "   lxc exec blazos-arch -- bash"
echo "   lxc exec blazos-alpine-322 -- sh"

echo ""
echo "🛠️ BULK COMMANDS:"
echo "   lxc start --all                      # Start everything"
echo "   lxc stop --all                       # Stop everything"
echo "   lxc restart --all                    # Restart everything"
echo "   lxc list | grep blazos               # View all"

echo ""
echo "🔍 DISTRIBUTION LIST:"
lxc list -c n | grep "blazos-" | awk '{print "   🐧 " $2}'

echo ""
echo "💡 PRO TIP:"
echo "   Use 'lxc exec [name] -- [command]' to run any command"
echo "   across any Linux distribution instantly!"
