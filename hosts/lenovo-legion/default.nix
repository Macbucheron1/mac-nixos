{ pkgs, config, ... }:
{
  imports = [
    ./hardware-configuration.nix
  ];

  boot = {
    loader = {
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        efiInstallAsRemovable = true;
      };
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = false;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest;
    blacklistedKernelModules = ["nouveau"];
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
  services.xserver.videoDrivers = ["nvidia"];

  powerManagement.enable = true;  # recommandé sur laptop
  services.upower.enable = true;  # batterie/AC state
  services.power-profiles-daemon.enable = true;

  # Fix for the wifi card going to deep sleep and never waking up
  powerManagement.powerDownCommands = ''
    ${pkgs.kmod}/bin/modprobe -r rtw89_8852ce || true
  '';
  powerManagement.resumeCommands = ''
    ${pkgs.kmod}/bin/modprobe rtw89_8852ce || true
    ${pkgs.util-linux}/bin/rfkill unblock wlan || true
    systemctl restart NetworkManager.service || true
  '';
}
