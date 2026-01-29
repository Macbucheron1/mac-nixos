{ ... }:
{
  services.kanshi = {
    enable = true;

    settings = [
      {
        profile = {
          name = "laptop";
          outputs = [
            {
              criteria = "eDP-1";
              status = "enable";
            }
          ];
          exec = "swaymsg 'workspace 0, move workspace to output eDP-1, workspace 1, move workspace to output eDP-1, workspace 1'";
        };
      }

      # Home 
      {
        profile = {
          name = "home";
          outputs = [
            { criteria = "HDMI-A-1"; status = "enable"; }
            { criteria = "DP-1";     status = "enable"; }
            { criteria = "eDP-1";    status = "enable"; }
          ];
          exec = "swaymsg 'workspace 0, move workspace to output eDP-1, workspace 1, move workspace to output HDMI-A-1, workspace 2, move workspace to output DP-1, workspace 3, move workspace to output eDP-1, workspace 1'";
        };
      }
    ];
  };
}

