# BlazOS 🔥

**The Ultimate Multi-Distro Linux Experience**

BlazOS is a live bootable ISO based on Ubuntu 25.10 that lets you run and switch between 20 different Linux distributions using LXD containers.

## ✨ Features

- 🚀 **20 Linux Distros** ready to launch
- 💨 **Instant switching** between distributions  
- 🎨 **Full desktop environments** for each distro
- 💾 **Live USB bootable** - no installation required
- 🔧 **LXD-powered** - lightweight and efficient
- 🖥️ **Optimized for servers** with plenty of RAM

## 📦 Included Distributions

1. Ubuntu 22.04 & 24.04 LTS
2. Debian 11 & 12
3. Fedora 40 & 41
4. Arch Linux & Manjaro
5. openSUSE Leap & Tumbleweed
6. Kali Linux
7. Alpine Linux (Stable & Edge)
8. Rocky Linux 9
9. Alma Linux 9
10. CentOS Stream 9
11. Oracle Linux 9
12. Gentoo
13. Void Linux
14. Devuan

## 💻 System Requirements

### Recommended (Run all 20 distros)
- CPU: 8+ cores
- RAM: 64GB+
- Storage: 200GB+
- Graphics: Dedicated GPU

### Minimum (Run 2-3 distros)
- CPU: Dual-core
- RAM: 8GB
- Storage: 20GB
- Graphics: GPU with OpenGL support

## 🚀 Quick Start

### Download
Download the latest BlazOS ISO from [Releases](https://github.com/paulblazevic/blazos/releases)

### Create Bootable USB
```bash
# Linux
sudo dd if=BlazOS.iso of=/dev/sdX bs=4M status=progress && sync

# Windows - use Rufus or Etcher
