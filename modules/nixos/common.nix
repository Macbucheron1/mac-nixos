{ config, lib, pkgs, ... }:
{
  imports = [ 
    ./desktop/gnome.nix
    ./users/mac.nix
  ];


  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "fr";
  services.xserver.xkb.layout = "fr";

  time.timeZone = "Europe/Paris";


  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  programs.ssh = {
    startAgent = true;
    knownHosts.github = {
      hostNames = [ "github.com" ];
      publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
    };
  };

  environment.systemPackages = with pkgs; [
    firefox
    vscode
    tree
    python3
    pipx 
    discord
  ];

  virtualisation.docker.enable = true;
}
