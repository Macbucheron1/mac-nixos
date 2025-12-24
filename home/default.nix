{ config, pkgs, username, homeManagerStateVersion, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = homeManagerStateVersion;

  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home.packages = with pkgs; [
    vim
  ];

  imports = [
    ./zellij
    ./nvim
    ./bash
    ./foot
    ./git
    ./vscode
    ./firefox
  ];
}
