
{ config, pkgs, lib, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;

  # VPN interfaces that will be detected
  vpnIfaces = [ "wg0" "tun0" "tailscale0" ];

  scripts = import ./scripts { inherit pkgs lib vpnIfaces; };

  mkCustomJson = { exec, execIf ? null, interval ? 5 }:
    {
      inherit interval;
      return-type = "json";
      format = "{}";
      hide-empty-text = true;
      tooltip = false;
      inherit exec;
    }
    // (if execIf == null then {} else { "exec-if" = execIf; });


  styleFile = pkgs.replaceVars ./style.css {
    inherit (colors)
      base00 base01 base02 base05 base07
      base08 base0A base0B base0D base0E;
  };

in
{
  stylix.targets.waybar = {
    enable = true;
    addCss = false;
    enableLeftBackColors = false;
    enableCenterBackColors = false;
    enableRightBackColors = false;
  };

  programs.waybar = {
    enable = true;
    systemd.enable = false;

    settings = {
      mainBar = {
        layer = "top";
        position = "bottom";
        height = 28;
        spacing = 6;

        modules-left = [ "sway/workspaces" ];
        modules-right = [ "custom/lan" "custom/vpn" "battery" "clock" ];

        "sway/workspaces" = {
          format = "{index}";
          all-outputs = false;
          disable-scroll = true;
        };

        "custom/lan" = mkCustomJson {
          exec = "${scripts.lanIp}/bin/waybar-lan-ip";
          interval = 5;
        };

        "custom/vpn" = mkCustomJson {
          execIf = "${scripts.vpnUp}/bin/waybar-vpn-up";
          exec = "${scripts.vpnIp}/bin/waybar-vpn-ip";
          interval = 5;
        };

        battery = {
          format = "{capacity}%";
          interval = 10;
          tooltip = false;
        };

        clock = {
          format = "{:%d/%m %H:%M}";
          interval = 60;
          tooltip = false;
        };
      };
    };

    
    style = builtins.readFile styleFile;
  };
}

