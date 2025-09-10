#!/usr/bin/env bash
set -euo pipefail

DISK=/dev/vda
HOST=vm   # change this if your flake uses another nixosConfigurations.<host>

echo "==> Partitioning $DISK (GPT + EFI + swap + root)..."
parted --script "$DISK" mklabel gpt
parted --script "$DISK" mkpart ESP fat32 1MiB 513MiB
parted --script "$DISK" set 1 esp on
parted --script "$DISK" mkpart primary linux-swap 513MiB 2561MiB
parted --script "$DISK" mkpart primary ext4 2561MiB 100%

echo "==> Formatting partitions..."
mkfs.fat -F32 ${DISK}1
mkswap ${DISK}2
swapon ${DISK}2
mkfs.ext4 -L nixos ${DISK}3

echo "==> Mounting filesystems..."
mount /dev/disk/by-label/nixos /mnt
mkdir -p /mnt/boot
mount ${DISK}1 /mnt/boot

echo "==> Generating hardware-configuration.nix..."
nixos-generate-config --root /mnt
mv /mnt/etc/nixos/hardware-configuration.nix

echo "==> Cloning your NixOS config from GitHub..."
rm -rf /mnt/etc/nixos
git clone https://github.com/Macbucheron1/mac-nixos /mnt/etc/nixos
mv /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/hosts/${HOST}/hardware-configuration.nix

echo "==> Installing NixOS using flake output: #$HOST"
nixos-install --root /mnt --flake /mnt/etc/nixos#$HOST

echo "==> Installation complete!"
echo "Reboot now with:  reboot"
