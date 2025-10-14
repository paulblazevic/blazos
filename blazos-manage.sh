#!/bin/bash
echo "🛠️ BLAZOS CONTAINER MANAGEMENT"

case $1 in
    list)
        lxc list
        ;;
    start)
        lxc start "blazos-$2"
        ;;
    stop)
        lxc stop "blazos-$2"
        ;;
    shell)
        lxc exec "blazos-$2" -- bash
        ;;
    info)
        lxc exec "blazos-$2" -- cat /etc/os-release | grep PRETTY_NAME
        ;;
    *)
        echo "Usage: $0 {list|start|stop|shell|info} [distro]"
        echo "Available distros:"
        echo "  - ubuntu (24.04)"
        echo "  - alpine (3.19)"
        echo "  - debian (12)"
        echo ""
        echo "Examples:"
        echo "  $0 list"
        echo "  $0 shell ubuntu"
        echo "  $0 info alpine"
        ;;
esac
