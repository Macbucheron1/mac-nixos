{ modulesPath, ... }:

{
  imports = [
    ./hardware-configuration.nix
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/vda";
  boot.loader.grub.useOSProber = false;
  virtualisation.vmVariant = {
    virtualisation.diskSize = 8192;  
    virtualisation.memorySize = 4096; 
    virtualisation.cores = 2;      
  };

}
