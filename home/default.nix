{ config, pkgs, username, homeManagerStateVersion, nixpkgs, ... }:
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = homeManagerStateVersion;
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Usefull cli
    file
    tree
    nitch
    wl-clipboard
    libnotify
    brightnessctl
    ripgrep
    pciutils
    
    # Photo capture & Video capture
    grim
    slurp
  ];

  stylix.targets.nvf.enable = false;

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
    ./nvf
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
