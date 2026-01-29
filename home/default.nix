{ pkgs, username, homeManagerStateVersion, ... }:
let
  myCustomPkgs = import ../pkgs { inherit pkgs; };
in
{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = homeManagerStateVersion;
  nixpkgs.config.allowUnfree = true;

  programs.home-manager.enable = true;

  home.packages = (with pkgs; [
    # Usefull cli
    file
    nitch
    wl-clipboard
    libnotify
    brightnessctl
    ripgrep
    pciutils
    eza
    wget
    nur.repos.hexadecimalDinosaur.fzf-tab-completion
    nsearch

    # Photo capture & Video capture
    slurp
    obsidian
    signal-desktop
  ]) ++ (with myCustomPkgs; [
    exegol
  ]);

  stylix.targets.nvf.enable = false;

  services.udiskie = {
    enable = true;
    automount = true;
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
    ./mako
    ./nixcord
    ./virtmanager
    ./waybar
    ./fzf
    ./batsignal
    ./avizo
    ./yazi
    ./xdg
  ];
}
