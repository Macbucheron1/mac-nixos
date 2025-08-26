{ inputs, lib, pkgs, userName, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "vm";
  time.timeZone = "Europe/Paris";

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "wheel docker" ];
  };

  system.stateVersion = "25.05";
}
