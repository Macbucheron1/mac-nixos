# Mac NixOS Configuration

A modular NixOS configuration using flakes, Home Manager, and declarative disk partitioning with Disko. Features a Sway-based desktop environment with a global Gruvbox theme managed by Stylix.

## Installation

> [!CAUTION]
>  installation will wiped the disk you select

### Remote installation

Install from any machine with Nix to a target machine over SSH:

```bash
nix run github:Macbucheron1/mac-nixos#install -- --target root@<target-ip>:22
```

### Test in a VM

Test the configuration in a virtual machine:

```bash
./build-vm.sh
```

## Managing the System

> [!IMPORTANT]
> Make sur to have this repo in `~/Documents/mac-nixos`. Otherwise you will need to modify `home/nh/default.nix`

### Update all inputs

```bash
nix flake update
```

### Rebuild system

```bash
nh os switch
```

### Update Home Manager only

```bash
nh home switch
```
