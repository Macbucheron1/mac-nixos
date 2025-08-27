{ userName, config, pkgs, lib, ... }:

{
  home.username = "${userName}";
  home.homeDirectory = "/home/${userName}";
  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

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
    ./gnome
    ./git
  ];
}

