{ pkgs, username, hostname, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking =  {
    hostName = hostname;
    networkmanager.enable = true;
  };

  # PipeWire + Pulse shim
  services.pipewire = {
    enable = true;
    audio.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;

    # vibe coded fix for airpods autoconnect 
    extraConfig.pipewire-pulse."10-switch-on-connect.conf" = {
      "pulse.cmd" = [
        { cmd = "load-module"; args = "module-switch-on-connect"; }
      ];
    };
    wireplumber.extraConfig = {
      "11-bluetooth-policy.conf" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };
      "12-airpods-a2dp.conf" = {
        "monitor.bluez.rules" = [
          {
            matches = [
              { "device.name" = "bluez_card.34_0E_22_96_86_69"; }
            ];
            actions = {
              update-props = {
                "device.profile" = "a2dp-sink";
                "bluez5.auto-connect" = [ "a2dp_sink" ];
                "bluez5.hw-volume" = [ "a2dp_sink" ];
              };
            };
          }
        ];
      };
    };
  };
  # ---------------------

  security.rtkit.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  systemd.services.rfkill-unblock-bluetooth = {
    description = "Unblock Bluetooth rfkill at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-rfkill.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
    };
  };

  security.pam.services.swaylock = {};

  services.udisks2.enable = true;

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  users.users.${username} = {
    isNormalUser = true;
    initialPassword = "changeme";
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    home-manager
    bluetui
  ];

  imports = [
    ./docker
    #./virtualbox
    # ./virtmanager
    ./cachix
  ];
  
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "25.05";
}
