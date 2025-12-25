{ config, pkgs, username, homeManagerStateVersion, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = homeManagerStateVersion;

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;

  home.packages = with pkgs; [
    tree
  ];

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
  ];
}
