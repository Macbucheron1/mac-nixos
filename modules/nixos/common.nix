# modules/nixos/common.nix
{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./users/mac
    ./virtualisation
    ./ssh
    ./stylix
    ./nix
  ];


  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";
  services.xserver.xkb.layout = "fr";

  time.timeZone = "Europe/Paris";

  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;

  services.usbmuxd.enable = true; # usb multiplexing daemon for ios devices

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    pciutils # Fournit lspci 

    tree
    bind # Fournit dig, nslookup, ...
    
    # USB thethering IOS
    libimobiledevice 

    # Eduroam pour se connnecter au wifi de l'école
    geteduroam-cli

    # Pour monter des systèmes de fichiers virtiofs
    virtiofsd

    # Bat
    bat
    bat-extras.batman

    # Coreutils
    file

    python312

    brightnessctl
  ];

  programs.steam.enable = true;

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  virtualisation.docker = {
    enable = true;
    daemon.settings."bip" = "172.30.0.1/24";
        daemon.settings."default-address-pools" = [
      { base = "172.29.0.0/16"; size = 24; }
    ];
  };
}

