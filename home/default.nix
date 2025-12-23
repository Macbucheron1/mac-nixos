{ config, pkgs, username, stateVersion, ... }:

{
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = stateVersion;

  programs.home-manager.enable = true;
  programs.bash.enable = true;

  home.packages = with pkgs; [
    vim
  ];
}
