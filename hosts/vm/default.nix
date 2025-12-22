{ modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = false;
}
