{ ... }:
{
wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true; # Fixes common issues with GTK 3 apps
    config = rec {
      modifier = "Mod4";
      terminal = "foot"; 
      startup = [
        { command = "foot"; }
      ];
    };
  };
}
