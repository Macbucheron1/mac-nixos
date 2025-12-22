{ config, pkgs, username, hostname, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "us";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
    initialPassword = "changeme";
  };

  environment.systemPackages = with pkgs; [
    git
    vim
  ];

  system.stateVersion = "25.05";
  system.nixos.label = "lenovo-legion-tryout";
  
}
