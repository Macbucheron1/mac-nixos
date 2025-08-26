{ inputs, lib, pkgs, user, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/desktop/gnome.nix
  ];

  networking.hostName = "vm";
  time.timeZone = "Europe/Paris";

  users.users.${user} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
