{ inputs, lib, pkgs, userName, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/desktop/gnome.nix
  ];

  networking.hostName = "vm";
  time.timeZone = "Europe/Paris";

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
