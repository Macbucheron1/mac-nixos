
{ config, pkgs, ... }:

let
  c = config.lib.stylix.colors;
  node = pkgs.nodejs;

  # Possible vpn interfaces
  vpnIfaces = [ "wg0" "tun0" "tailscale0" ];
  vpnIfacesJs = builtins.toJSON vpnIfaces;

  waybarVpnUp = pkgs.writeScriptBin "waybar-vpn-up" ''
    #!${node}/bin/node
    "use strict";

    const { execSync } = require("child_process");
    const VPN = ${vpnIfacesJs};

    function cmdOk(cmd) {
      try {
        execSync(cmd, { stdio: "ignore" });
        return true;
      } catch (_) {
        return false;
      }
    }

    for (const dev of VPN) {
      if (cmdOk("${pkgs.iproute2}/bin/ip link show " + dev)) {
        process.exit(0); // VPN up => exec-if OK
      }
    }
    process.exit(1); // VPN down => module caché
  '';

  waybarVpnIp = pkgs.writeScriptBin "waybar-vpn-ip" ''
    #!${node}/bin/node
    "use strict";

    const { execSync } = require("child_process");
    const VPN = ${vpnIfacesJs};

    function sh(cmd) {
      return execSync(cmd, { encoding: "utf8" }).trim();
    }

    function getIfaceIp(dev) {
      try {
        const out = sh("${pkgs.iproute2}/bin/ip -4 -o addr show dev " + dev + " scope global");
        // Exemple: "5: wg0    inet 10.10.0.2/32 brd 10.10.0.2 scope global ..."
        const m = out.match(/inet\s+(\d+\.\d+\.\d+\.\d+)\//);
        return m ? m[1] : null;
      } catch (_) {
        return null;
      }
    }

    for (const dev of VPN) {
      // If interface exist, get the ip
      try { execSync("${pkgs.iproute2}/bin/ip link show " + dev, { stdio: "ignore" }); } catch (_) { continue; }
      const ip = getIfaceIp(dev);
      if (ip) {
        process.stdout.write(JSON.stringify({ text: ip }));
        process.exit(0);
      }
      process.exit(0);
    }

    process.stdout.write(JSON.stringify({ text: "" }));
  '';

  waybarLanIp = pkgs.writeScriptBin "waybar-lan-ip" ''
    #!${node}/bin/node
    "use strict";

    const { execSync } = require("child_process");

    const excluded = new Set(["lo", ...${vpnIfacesJs}]);

    function sh(cmd) {
      return execSync(cmd, { encoding: "utf8" }).trim();
    }

    function isPrivateRFC1918(ip) {
      if (ip.startsWith("10.")) return true;
      if (ip.startsWith("192.168.")) return true;
      if (ip.startsWith("172.")) {
        const parts = ip.split(".");
        const o2 = parseInt(parts[1], 10);
        return o2 >= 16 && o2 <= 31;
      }
      return false;
    }

    let out = "";
    try {
      out = sh("${pkgs.iproute2}/bin/ip -4 -o addr show scope global");
    } catch (_) {
      process.exit(1);
    }

    const lines = out.split("\n").filter(Boolean);

    for (const line of lines) {
      // Format: "2: wlp2s0    inet 192.168.1.42/24 brd ..."
      const m = line.match(/^\d+:\s+(\S+)\s+inet\s+(\d+\.\d+\.\d+\.\d+)\//);
      if (!m) continue;

      const dev = m[1];
      const ip = m[2];

      if (excluded.has(dev)) continue;
      if (!isPrivateRFC1918(ip)) continue;

      process.stdout.write(JSON.stringify({ text: ip }));
      process.exit(0);
    }

    process.exit(1);
  '';
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

        "custom/lan" = {
          exec = "${waybarLanIp}/bin/waybar-lan-ip";
          return-type = "json";
          interval = 5;
          format = "{}";
          hide-empty-text = true;
          tooltip = false;
        };

        "custom/vpn" = {
          exec-if = "${waybarVpnUp}/bin/waybar-vpn-up";
          exec = "${waybarVpnIp}/bin/waybar-vpn-ip";
          return-type = "json";
          interval = 5;
          format = "{}";
          hide-empty-text = true;
          tooltip = false;
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
        border-radius: 10px;
        min-height: 0;
        font-size: 12px;
      }

      window#waybar {
        background: #${c.base00};
        color: #${c.base05};
      }

      #custom-lan, #custom-vpn, #battery, #clock {
        background: #${c.base01};
        padding: 0 10px;
        margin: 4px 0;
      }

      #workspaces button {
        background: transparent;
        color: #${c.base05};
        padding: 0 8px;
        margin: 4px 2px;
        border-radius: 10px;
      }

      #workspaces button.focused {
        background: #${c.base02};
      }

      #workspaces button.urgent {
        background: #${c.base08};
        color: #${c.base00};
      }
    '';
  };
}

