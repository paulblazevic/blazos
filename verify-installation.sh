#!/bin/bash
echo "🔍 BLAZOS INSTALLATION VERIFICATION"
echo "==================================="

echo "📊 Checking distribution status..."
total=$(lxc list -c n | grep "blazos-" | wc -l)
running=$(lxc list -c ns | grep "blazos-" | grep "RUNNING" | wc -l)

echo ""
echo "📈 INSTALLATION SUMMARY:"
echo "   Total Distributions: $total/17"
echo "   Currently Running: $running"
echo "   Stopped: $((total - running))"

echo ""
echo "🐧 AVAILABLE DISTRIBUTIONS:"
lxc list -c n | grep "blazos-" | awk '{print "   ✅ " $2}'

echo ""
if [ $total -ge 15 ]; then
    echo "🎉 SUCCESS! BlazOS is ready with $total distributions!"
else
    echo "⚠️  Partial installation: $total distributions"
fi
