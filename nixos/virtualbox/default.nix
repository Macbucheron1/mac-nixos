{ lib, pkgs, username, ... }:
{
  virtualisation.virtualbox.host.enable = true;
  virtualisation.virtualbox.host.enableExtensionPack = true;

  users.users.${username}.extraGroups = [ "vboxusers" ];

  # The upstream NixOS module rebuilds the kernel modules with an override that
  # drops our linux_6_19 overlay patch. Force the already-patched package instead.
  boot.extraModulePackages = lib.mkForce [ pkgs.linuxPackages_latest.virtualbox ];
}
