#!/bin/bash
echo "📱 CREATING DESKTOP SHORTCUT"
echo "============================"

# Create desktop entry
mkdir -p ~/Desktop
cat > ~/Desktop/blazos-launcher.desktop << 'DESKTOP'
[Desktop Entry]
Version=1.0
Type=Application
Name=BlazOS Launcher
Comment=Launch 17 Linux Distributions
Exec=/home/paul/blazos/blazos-gui-launcher.sh
Icon=/usr/share/icons/Adwaita/48x48/apps/system-software-install.png
Terminal=false
Categories=System;
StartupNotify=true
DESKTOP

chmod +x ~/Desktop/blazos-launcher.desktop

# Also create in autostart for easy access
mkdir -p ~/.local/share/applications
cp ~/Desktop/blazos-launcher.desktop ~/.local/share/applications/

echo "✅ Desktop shortcut created!"
echo "📱 Look for 'BlazOS Launcher' on your desktop"
echo ""
echo "🖱️ Double-click to launch the distribution selector"
