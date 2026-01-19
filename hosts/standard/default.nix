{ lib, modulesPath, ... }:
{
  imports =
    [
      # useful for compatability on bare metal
      (modulesPath + "/installer/scan/not-detected.nix")
    ]
    ++ lib.optionals (builtins.pathExists ./hardware-configuration.nix) [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;
}

