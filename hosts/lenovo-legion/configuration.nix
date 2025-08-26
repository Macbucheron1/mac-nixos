{ inputs, lib, pkgs, userName, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
    ../../modules/nixos/desktop/gnome.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";      
    useOSProber = true;      
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-legion";
  time.timeZone = "Europe/Paris";

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
