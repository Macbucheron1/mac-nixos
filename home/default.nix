{ config, pkgs, username, homeManagerStateVersion, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = homeManagerStateVersion;

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    # Usefull cli
    file
    tree
    nitch
    wl-clipboard
    libnotify
    
    # Photo capture & Video capture
    grim
    slurp
  ];

  # Adds an entry to roff drun
  xdg.desktopEntries.nmtui = {
    name = "nmtui";
    comment = "NetworkManager TUI";
    type = "Application";
    terminal = false;
    categories = [ "System" "Network" ];
    exec = "${pkgs.foot}/bin/foot -e ${pkgs.networkmanager}/bin/nmtui";
  };

  imports = [
    ./zellij
    ./nvim
    ./bash
    ./foot
    ./git
    ./vscode
    ./firefox
    ./bat
    ./nh
    ./rofi
    ./vesktop
    ./mako
  ];
}
