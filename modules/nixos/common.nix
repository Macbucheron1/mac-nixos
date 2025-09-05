{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./desktop/gnome.nix
    ./users/mac.nix
    ./virtualisation
  ];


  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";
  services.xserver.xkb.layout = "fr";

  time.timeZone = "Europe/Paris";

  networking.networkmanager.enable = true;
  services.usbmuxd.enable = true; # usb multiplexing daemon for ios devices

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  programs.ssh = {
    startAgent = true;
    knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };

  environment.systemPackages = with pkgs; [
    tree
    python3
    pipx 
    discord
    nautilus
    exegol
    obsidian #https://discordapp.com/channels/568306982717751326/1283818433049530380/1383786696038027264
    
    # USB thethering IOS
    libimobiledevice 

    # Eduroam pour se connnecter au wifi de l'école
    geteduroam-cli
  ];

  virtualisation.docker.enable = true;
  xdg.mime.enable = true;
  xdg.mime.defaultApplications = {
    "inode/directory" = "org.gnome.Nautilus.desktop";
  };
}

