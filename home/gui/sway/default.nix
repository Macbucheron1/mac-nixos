{ ... }:
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
