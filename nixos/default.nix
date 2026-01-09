{ pkgs, username, hostname, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking =  {
    hostName = hostname;
    networkmanager.enable = true;
  };

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    extraConfig.pipewire-pulse."10-switch-on-connect.conf" = {
      "pulse.cmd" = [
        { cmd = "load-module"; args = "module-switch-on-connect"; }
      ];
    };
  };
  security.rtkit.enable = true;
  systemd.services.rfkill-unblock-bluetooth = {
    description = "Unblock Bluetooth rfkill at boot";
    wantedBy = [ "multi-user.target" ];
    after = [ "systemd-rfkill.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.util-linux}/bin/rfkill unblock bluetooth";
    };
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  security.pam.services.swaylock = {};

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" "libvirtd" ];
    initialPassword = "changeme";
  };

  environment.systemPackages = with pkgs; [
    home-manager
    bluetui
  ];

  imports = [
    ./docker
    ./virtualbox
    ./virtmanager
  ];

  system.stateVersion = "25.05";
}
