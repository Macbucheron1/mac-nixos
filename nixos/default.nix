{ pkgs, username, hostname, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking =  {
    hostName = hostname;
    networkmanager.enable = true;
    hosts = {
      "10.10.128.1" = ["controleur.wifipass.org" "cdn-wifi.tech"];
    };

    wg-quick.interfaces = {
      wg0 = {
        autostart = false;
        address = [ "10.254.3.2/24" ];
        privateKeyFile = "/etc/wireguard/arnaud_lab.key";
        peers = [
          {
            publicKey = "Vu/T8RTaZx38JBYPERdZd+LzJolJ3HUyPC4/8eqxLF8=";
            allowedIPs = [ "10.0.0.205/24" ];
            endpoint = "vpn.azertx.fr:51820";
          }
        ];
      };
      wg1 = {
        autostart = false;
        address = [ "198.51.100.5/32" ];
        privateKeyFile = "/etc/wireguard/arnaud_lab2.key";
        peers = [
          {
            publicKey = "hEou+iDJVVNPDjC6TfyM8YRI4XTxbGSQRYHVVcRCmCg=";
            allowedIPs = [ "198.51.100.1/32,10.1.0.0/16,10.8.0.0/16" ];
            endpoint = "10.0.0.205:51820";
          }
        ];
      };
    };

  };

  # PipeWire + Pulse shim
  services.pipewire = {
    enable = true;
    audio.enable = true;

    alsa.enable = true;
    alsa.support32Bit = true;

    pulse.enable = true;
  };

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
    extraGroups = [ "wireshark""wheel" "networkmanager" "libvirtd" ];
  };

  environment.systemPackages = with pkgs; [
    home-manager
    bluetui
    sbctl
    xhost
    xauth
  ];
  programs.wireshark.enable = true;

  imports = [
    ./docker
    ./virtualbox
    # ./virtmanager
    ./cachix
  ];

  nix = {
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
    optimise = {
      automatic = true;
      dates = "weekly";
    };
  };
  
  boot.initrd.verbose = false;
  boot.consoleLogLevel = 0;
  boot.kernelParams = [ "quiet" "udev.log_level=3" ];
  boot.plymouth.enable = true;
  boot.initrd.systemd.enable = true;

  system.stateVersion = "25.05";
}
