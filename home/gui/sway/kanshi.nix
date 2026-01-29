{ config, lib, pkgs, ... }:
{
  services.kanshi = {
    enable = true;
    profiles = {

      # Laptop only
      undocked = {
        name = "undocked";
        outputs = [
          {
            criteria = "eDP-1";
            status = "enable";
          }
        ];
        exec = "swaymsg 'workspace 1, move workspace to output eDP-1, workspace 1'";
      };

      # Just at chill guy at home with 2 external screen
      docked = {
        name = "docked";
        outputs = [
          { criteria = "HDMI-A-1"; status = "enable"; }
          { criteria = "DP-1";     status = "enable"; }
          { criteria = "eDP-1";    status = "enable"; }
        ];
        exec = "swaymsg 'workspace 1, move workspace to output HDMI-A-1, workspace 2, move workspace to output DP-1, workspace 3, move workspace to output eDP-1, workspace 1'";
      };

    };
  };
}

