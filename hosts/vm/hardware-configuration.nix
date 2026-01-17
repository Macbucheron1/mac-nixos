{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "ahci"
    "xhci_pci"
    "sd_mod"
  ];

  # IMPORTANT: avec disko, pas de fileSystems ici
  # IMPORTANT: avec disko, pas de swapDevices ici

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}

