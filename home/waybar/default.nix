
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
      base00 base01 base05 base07
      base08 base0A base0B base0D base0E ;
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


      "custom/lan" = (mkCustomJson {
        exec = "${scripts.lanIp}/bin/waybar-lan-ip";
        interval = 5;
      }) // {
        signal = 8;
        on-click = ''
          sh -c '
            json="$(${scripts.lanIp}/bin/waybar-lan-ip 2>/dev/null || true)"
            ip="$(printf "%s" "$json" | ${pkgs.jq}/bin/jq -r ".text")"
            [ -n "$ip" ] || exit 0

            printf "%s" "$ip" | ${pkgs.wl-clipboard}/bin/wl-copy --trim-newline

            rt="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
            flag="$rt/waybar-lan-copied"
            date +%s%3N > "$flag"
            pkill -RTMIN+8 waybar

            ( sleep 0.2; rm -f "$flag"; pkill -RTMIN+8 waybar ) >/dev/null 2>&1 &
          '
        '';
        format = "<span>󰈀 </span> {}";
      };

      "custom/vpn" = (mkCustomJson {
        execIf = "${scripts.vpnUp}/bin/waybar-vpn-up";
        exec = "${scripts.vpnIp}/bin/waybar-vpn-ip";
        interval = 5;
      }) // {
        signal = 9;
        on-click = ''
          sh -c '
            json="$(${scripts.vpnIp}/bin/waybar-vpn-ip 2>/dev/null || true)"
            ip="$(printf "%s" "$json" | ${pkgs.jq}/bin/jq -r ".text")"
            [ -n "$ip" ] || exit 0

            printf "%s" "$ip" | ${pkgs.wl-clipboard}/bin/wl-copy --trim-newline

            rt="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}"
            flag="$rt/waybar-vpn-copied"
            date +%s%3N > "$flag"
            pkill -RTMIN+9 waybar

            ( sleep 0.2; rm -f "$flag"; pkill -RTMIN+9 waybar ) >/dev/null 2>&1 &
          '
        '';
        format = "<span>󰖂 </span> {}"; 
      };




        battery = {
          interval = 10;
          tooltip = false;

          format = "<span>{icon} </span> {capacity}%";

          states = {
            warning = 30;
            critical = 15;
          };

          # Ordre: low -> high
          format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
        };


        clock = {
          interval = 60;
          tooltip = false;
          format = "<span>󰥔 </span> {:%d/%m/%Y %H:%M}";
        };
      };
    };

    
    style = builtins.readFile styleFile;
  };
}

