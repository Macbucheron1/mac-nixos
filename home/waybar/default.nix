{ config, pkgs, lib, vibepods, ... }:

let
  colors = config.lib.stylix.colors.withHashtag;

  # VPN interfaces that will be detected
  vpnIfaces = [ "wg0" "tun0" "tailscale0" ];

  vibepodsPkg =
    vibepods.packages.${pkgs.stdenv.hostPlatform.system}.vibepods_cli
    or vibepods.packages.${pkgs.stdenv.hostPlatform.system}.default;

  scripts = import ./scripts {
    inherit pkgs lib vpnIfaces vibepodsPkg;
  };

  mkCustomJson = { exec, execIf ? null, interval ? 5 }:
    {
      inherit interval;
      return-type = "json";
      format = "{}";
      hide-empty-text = true;
      tooltip = false;
      inherit exec;
    }
    // (if execIf == null then { } else { "exec-if" = execIf; });

  styleFile = pkgs.replaceVars ./style.css {
    inherit (colors)
      base00
      base01
      base05
      base07
      base08
      base0A
      base0B
      base0D
      base0E;
  };
in
{
  systemd.user.services.vibepods-daemon = {
    Unit = {
      Description = "VibePods persistent daemon";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      ExecStart = "${vibepodsPkg}/bin/vibepods-daemon --output %t/vibepods/status.json --snapshot-interval 0";
      Restart = "on-failure";
      RestartSec = 2;
      RuntimeDirectory = "vibepods";
    };

    Install.WantedBy = [ "default.target" ];
  };

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
        modules-right = [ "custom/lan" "custom/vpn" "custom/airpods" "battery" "clock" ];

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

        "custom/airpods" = (mkCustomJson {
          exec = "${scripts.airpods}/bin/waybar-airpods";
          interval = 5;
        }) // {
          escape = false;
          tooltip = true;
          on-click = "${scripts.airpodsMode}/bin/waybar-airpods-mode";
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
