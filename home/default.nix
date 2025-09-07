{ userName, catppuccin, config, pkgs, lib, ... }:

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
  ];

  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        "inode/directory" = "org.gnome.Nautilus.desktop";
        "application/x-directory" = "org.gnome.Nautilus.desktop";
        "image/*" = "org.gnome.Shotwell.desktop";
        "video/*" = "io.github.celluloid_player.desktop";
        "audio/*" = "org.gnome.Rhythmbox3.desktop";
      }; 
    };

    userDirs = {
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
  };

  imports = [
    ./vscode
    ./gnome
    ./git
    ./firefox
    ./alacritty
    ./fastfetch
    catppuccin.homeModules.catppuccin
  ];

  catppuccin.enable = true;
}

