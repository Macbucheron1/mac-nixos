{ inputs, lib, pkgs, userName, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ../../modules/nixos/common.nix
  ];

  boot.loader.grub = {
    enable = true;
    efiSupport = true;
    device = "nodev";      
    useOSProber = true;      
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "lenovo-legion";

  users.users.${userName} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
  };

  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
      open = false;
      modesetting.enable = true;
      nvidiaSettings = true;
      prime = {
        offload.enable = true;
        offload.enableOffloadCmd = true; 
        amdgpuBusId = "PCI:5:0:0";
        nvidiaBusId = "PCI:1:0:0";
        sync.enable = false;
        reverseSync.enable = false;
      };
    };
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  system.stateVersion = "25.05";
}
