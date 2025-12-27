{ pkgs, lib, ... }:
let 
  volumeScript = ./script/volume-notify.sh;
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      startup = [
        { command = "foot"; }
      ];
      input."*".xkb_layout = "fr";
      keybindings = lib.mkOptionDefault {
        "${modifier}+p" = "exec rofi -show drun"; 
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";
        "XF86AudioMute" = "exec bash ${volumeScript} mute";
        "XF86AudioRaiseVolume" = "exec bash ${volumeScript} up";
        "XF86AudioLowerVolume" = "exec bash ${volumeScript} down";
      };
      bars = [
        {
          fonts = {
            names = [ "DejaVu Sans Mono" ];
            size = 14.0;
          };

          statusCommand = "${pkgs.i3status}/bin/i3status";

          position = "bottom";
          workspaceButtons = true;
          workspaceNumbers = true;
          trayOutput = "primary";
        }
      ];
    };
    extraConfig = ''
      # No titlebar, keep a 1px border
      default_border pixel 1
      default_floating_border pixel 1
    '';
  };

  # https://wiki.nixos.org/wiki/Sway
  # It's recommended to enable a Secret Service provider, like GNOME Keyring
  services.gnome-keyring.enable = true;
}
