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
    };
  };

  # https://wiki.nixos.org/wiki/Sway
  # It's recommended to enable a Secret Service provider, like GNOME Keyring
  services.gnome-keyring.enable = true;
}
