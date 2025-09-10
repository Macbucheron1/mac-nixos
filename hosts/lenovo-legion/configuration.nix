# hosts/lenovo-legion/configuration.nix
{ inputs, lib, pkgs, userName, ... }:
{
  imports = [
    ./hardware-configuration.nix
 ];

  boot.loader = {
    grub = {
      enable = true;
      efiSupport = true;
      device = "nodev";      
      useOSProber = true; 
    };
    efi = {
      efiSysMountPoint = "/boot";
      canTouchEfiVariables = true;
    };
  };

  fileSystems."/boot".neededForBoot = true;


  networking.hostName = "lenovo-legion";

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

    nvidia-container-toolkit.enable = true;
  };

  services.xserver.videoDrivers = [ "nvidia" ];


  environment.systemPackages = with pkgs; [
    nvidia-container-toolkit
  ];

  system.stateVersion = "25.05";
}
