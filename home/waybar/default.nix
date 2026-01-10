
{ config, pkgs, lib, ... }:

let
  c = config.lib.stylix.colors;

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

    
    style = ''
      * {
        border: none;
        border-radius: 12px;
        min-height: 0;
        font-size: 12px;
      }

      window#waybar {
        background: rgba(0,0,0,0);
        color: #${c.base05};
      }

      /* Conteneur principal */
      
      #waybar {
        background: #${c.base00};
        border: 1px solid #${c.base02};
        border-radius: 0px;     /* rectangulaire */
        margin: 0px;            /* optionnel: plus "barre" */
        padding: 4px 8px;
      }


      /* Style commun aux "pills" (modules) */
      #custom-lan, #custom-vpn, #battery, #clock {
        background: #${c.base01};
        padding: 0 12px;
        margin: 4px 5px;
        border-radius: 12px;
        border: 1px solid #${c.base02};
        color: #${c.base05};
      }

      /* Accents par module (plus coloré, mais propre) */
      #custom-lan {
        border-left: 4px solid #${c.base0D}; /* bleu */
        background: #${c.base01};
      }

      #custom-vpn {
        border-left: 4px solid #${c.base0B}; /* vert */
        background: #${c.base01};
      }

      #battery {
        border-left: 4px solid #${c.base0A}; /* jaune */
        background: #${c.base01};
      }

      #clock {
        border-left: 4px solid #${c.base0E}; /* violet */
        background: #${c.base01};
      }

      /* Etats batterie (Waybar applique ces classes automatiquement) */
      #battery.charging {
        border-left-color: #${c.base0B};
        color: #${c.base0B};
      }

      #battery.warning {
        border-left-color: #${c.base0A};
        color: #${c.base0A};
      }

      #battery.critical {
        border-left-color: #${c.base08};
        color: #${c.base08};
        border-color: #${c.base08};
      }

      /* Workspaces */
      #workspaces {
        background: #${c.base01};
        border: 1px solid #${c.base02};
        border-radius: 14px;
        margin: 4px 6px;
        padding: 0 6px;
      }

      #workspaces button {
        background: transparent;
        color: #${c.base05};
        padding: 0 10px;
        margin: 4px 3px;
        border-radius: 10px;
        transition: all 120ms ease-in-out;
      }

      #workspaces button:hover {
        background: #${c.base02};
        color: #${c.base07};
      }

      #workspaces button.focused {
        background: #${c.base0D};
        color: #${c.base00};
      }

      #workspaces button.urgent {
        background: #${c.base08};
        color: #${c.base00};
      }

      /* Optionnel : petit “glow” discret quand un module est affiché */
      #custom-lan, #custom-vpn, #battery, #clock {
        box-shadow: 0 0 0 1px rgba(0,0,0,0.12);
      }
    '';
  };
}

