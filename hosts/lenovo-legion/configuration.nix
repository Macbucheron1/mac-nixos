# hosts/lenovo-legion/configuration.nix
{ inputs, lib, pkgs, userName, ... }:
{
  imports = [ ./hardware-configuration.nix ];

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

  # Fixing the wifi
  boot.extraModprobeConfig = ''
    options rtw89pci disable_clkreq=Y disable_aspm_l1=Y disable_aspm_l1ss=Y
  '';
  environment.etc."systemd/system-sleep/rtw89-reset".text = ''
    #!/bin/sh
    case "$1" in
      pre)  modprobe -r rtw89_8852ce rtw89pci rtw89core 2>/dev/null || true ;;
      post) modprobe rtw89_8852ce 2>/dev/null || true ;;
    esac
  '';
  environment.etc."systemd/system-sleep/rtw89-reset".mode = "0755";
  boot.kernelParams = [ "mem_sleep_default=deep" ];

  fileSystems."/boot".neededForBoot = true;

  networking.hostName = "lenovo-legion";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;        # amdgpu par défaut
  };

  # Par défaut: on NE charge PAS NVIDIA
  services.xserver.videoDrivers = [ "amdgpu" ];
  boot.blacklistedKernelModules = [ "nvidia" "nvidia_drm" "nvidia_modeset" "nvidia_uvm" ];

  ############################################
  ## Spécialisations NVIDIA
  ############################################
  specialisation = {

    # === Mode gaming / performance ===
    gaming-nvidia.configuration = {
      # On autorise les modules NVIDIA et on les sélectionne avec X
      boot.blacklistedKernelModules = lib.mkForce [ ];
      services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        nvidiaSettings = true;
        powerManagement.enable = false;
        prime = {
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
          offload.enable = false;
          sync.enable = lib.mkForce false;
          reverseSync.enable = lib.mkForce true;
        };
      };
      hardware.nvidia-container-toolkit.enable = true;
      environment.systemPackages = with pkgs; [ nvidia-container-toolkit ];
      environment.variables = {
        __GL_SYNC_TO_VBLANK = "1";
        __GL_MaxFramesAllowed = "1";
      };
    };

    # === Mode basse conso (offload) ===
    offload.configuration = {
      boot.blacklistedKernelModules = lib.mkForce [ ];
      services.xserver.videoDrivers = [ "amdgpu" "nvidia" ];
      hardware.nvidia = {
        open = false;
        modesetting.enable = true;
        powerManagement.enable = lib.mkForce true;
        prime = {
          amdgpuBusId = "PCI:5:0:0";
          nvidiaBusId = "PCI:1:0:0";
          offload.enable = lib.mkForce true;
          offload.enableOffloadCmd = lib.mkForce true;
          sync.enable = lib.mkForce false;
          reverseSync.enable = lib.mkForce false;
        };
      };
      hardware.nvidia-container-toolkit.enable = true;
      environment.shellAliases = { "offload" = "nvidia-offload"; };
    };
  };

  system.stateVersion = "25.05";
}
