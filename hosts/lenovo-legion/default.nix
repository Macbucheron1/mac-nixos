{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = true;
      };
      grub.enable = false;
    };

    blacklistedKernelModules = [ "nouveau" ];
    kernelParams = [
      "modprobe.blacklist=nouveau"
      "nouveau.modeset=0"
    ];
  };

  # TO DO: create a specialisation to run with/without dGPU
  hardware = {
    graphics = {
      enable = true;
      enable32Bit = true;
    };

    nvidia = {
    	package = config.boot.kernelPackages.nvidiaPackages.stable;
	    modesetting.enable = true;
    	powerManagement.enable = true;
    	open = false;
	    nvidiaSettings = true;

	    prime = {
	      offload.enable = true;
	      offload.enableOffloadCmd = true;
	      nvidiaBusId = "PCI:1:0:0";
	      amdgpuBusId = "PCI:5:0:0";
  	  };
    };
  };
  services.xserver.videoDrivers = [ "amdgpu" "nvidia"];

  powerManagement.enable = true;  # recommandé sur laptop
  services.upower.enable = true;  # batterie/AC state
  services.power-profiles-daemon.enable = true;

  hardware.nvidia-container-toolkit = {
    enable = true;
  };
  virtualisation.docker.daemon.settings.features.cdi = true;
}
