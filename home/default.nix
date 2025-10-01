{ userName, config, pkgs, lib, ... }:

{
  home.username = "${userName}";
  home.homeDirectory = "/home/${userName}";
  home.stateVersion = "25.11";
  
  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    shotwell    # images
    rhythmbox   # audio
    celluloid   # vidéo (GTK4/libadwaita)
    exegol

    nautilus # Explorateur de fichiers GNOME
    obsidian #https://discordapp.com/channels/568306982717751326/1283818433049530380/1383786696038027264
    libreoffice

  ];

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop     = "$HOME/Desktop";
    download    = "$HOME/Downloads";  
    documents   = "$HOME/Documents";
    music       = "$HOME/Music";
    pictures    = "$HOME/Pictures";
    videos      = "$HOME/Videos";
    publicShare = "$HOME/Public";
    templates   = "$HOME/Templates";
  };

  imports = [
    ./vscode
    ./desktop
    ./git
    ./firefox
    ./alacritty
    ./fastfetch
    ./vesktop
    ./bash
    ./starship
  ];

}

