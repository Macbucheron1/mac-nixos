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
    presenterm
    
    # Photo capture & Video capture
    slurp
    obsidian
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
    ./vesktop
    ./mako
    ./virtmanager
    ./waybar
    ./fzf
    ./avizo
    ./yazi
    ./xdg
  ];
}
