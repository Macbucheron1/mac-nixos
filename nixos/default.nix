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

    # Auto-switch du sink à la connexion (via pipewire-pulse)
    extraConfig.pipewire-pulse."10-switch-on-connect.conf" = {
      "pulse.cmd" = [
        { cmd = "load-module"; args = "module-switch-on-connect"; }
      ];
    };

    # WirePlumber: règles Bluetooth
    wireplumber.extraConfig = {
      # 1) Ne PAS auto-basculer en profil "headset" (HSP/HFP) dès qu'une app touche au micro
      "11-bluetooth-policy.conf" = {
        "wireplumber.settings" = {
          "bluetooth.autoswitch-to-headset-profile" = false;
        };
      };

      # 2) Forcer A2DP comme profil initial + auto-connect A2DP pour tes AirPods (MAC: 34:0E:22:96:86:69)
      "12-airpods-a2dp.conf" = {
        "monitor.bluez.rules" = [
          {
            matches = [
              { "device.name" = "bluez_card.34_0E_22_96_86_69"; }
            ];
            actions = {
              update-props = {
                # profil initial quand le device se connecte
                "device.profile" = "a2dp-sink";

                # auto-connect prioritaire (tu peux garder uniquement a2dp_sink)
                "bluez5.auto-connect" = [ "a2dp_sink" ];

                # optionnel: hw volume sur A2DP
                "bluez5.hw-volume" = [ "a2dp_sink" ];
              };
            };
          }
        ];
      };
    };
  };

  # Realtime scheduling (recommandé pour PipeWire)
  security.rtkit.enable = true;

  # Bluetooth
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # Optionnel: unblock rfkill bluetooth au boot (tu l'avais déjà, je le laisse)
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

  time.timeZone = "Europe/Paris";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "fr";

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker" "vboxusers" "libvirtd" ];
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
