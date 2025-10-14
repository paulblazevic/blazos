#!/bin/bash
# Initialize LXD on first run

if lxc list &>/dev/null 2>&1; then
    echo "✅ LXD already initialized"
    exit 0
fi

echo "Initializing LXD..."

cat << 'EOFLXD' | lxd init --preseed
config:
  core.https_address: '[::]:8443'
  images.auto_update_interval: 0
networks:
- config:
    ipv4.address: auto
    ipv6.address: auto
  name: lxdbr0
  type: bridge
storage_pools:
- config:
    size: 50GB
  name: default
  driver: zfs
profiles:
- name: default
  devices:
    root:
      path: /
      pool: default
      type: disk
EOFLXD

echo "✅ LXD initialized successfully"
