{ inputs, lib, pkgs, userName, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";      
    useOSProber = true;      
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-legion";

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  system.stateVersion = "25.05";
}
