{...}:
{
programs.waybar = {
  enable = true;

  # Lancement automatique avec Sway (recommandé)
  systemd.enable = true;
  systemd.target = "sway-session.target"; # :contentReference[oaicite:3]{index=3}

  # IMPORTANT: settings = { mainBar = { ... }; } (pas une liste)
  settings = {
    mainBar = {
      layer = "top";
      position = "bottom";  # default est top si absent :contentReference[oaicite:4]{index=4}
      height = 36;          # Waybar essaie de respecter height si possible :contentReference[oaicite:5]{index=5}
      spacing = 10;

      margin-top = 8;
      margin-left = 10;
      margin-right = 10;
      margin-bottom = 10;

      modules-left = [ "sway/workspaces" "sway/mode" ];
      modules-center = [ "sway/window" ];
      modules-right = [
        "idle_inhibitor"
        "network"
        "pulseaudio"
        "cpu"
        "memory"
        "temperature"
        "battery"
        "clock"
        "tray"
      ];

      "sway/window" = { max-length = 70; };

      tray = { icon-size = 16; spacing = 8; };

      "sway/workspaces" = {
        format = "{icon}";
        disable-scroll = false;
        disable-scroll-wraparound = false;
        all-outputs = true;

        format-icons = {
          "1" = ""; "2" = ""; "3" = ""; "4" = ""; "5" = "";
          urgent = ""; focused = ""; default = "";
        };
      };

      network = {
        format-wifi = "󰤨 {signalStrength}%";
        format-ethernet = "󰈀 {ipaddr}";
        format-disconnected = "󰤭 off";
        tooltip-format = "{ifname}\n{ipaddr}\n{essid} ({signalStrength}%)";
      };

      pulseaudio = {
        format = "{icon} {volume}%";
        format-muted = "󰝟 muted";
        scroll-step = 5;
        on-click = "pavucontrol";
        format-icons = {
          default = [ "󰕿" "󰖀" "󰕾" ];
        };
      };

      cpu = { interval = 2; format = "󰍛 {usage}%"; };
      memory = { interval = 2; format = "󰘚 {percentage}%"; };
      temperature = { interval = 5; format = "󰔏 {temperatureC}°C"; };

      battery = {
        states = { warning = 30; critical = 15; };
        format = "{icon} {capacity}%";
        format-charging = "󰂄 {capacity}%";
        format-icons = [ "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹" ];
      };

      clock = {
        interval = 1;
        format = "󰥔 {:%a %d %b %H:%M}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = { mode = "month"; weeks-pos = "right"; };
      };

      idle_inhibitor = {
        format = "{icon}";
        format-icons = { activated = "󰅶"; deactivated = "󰾪"; };
      };
    };
  };

  style = ''
    * {
      font-family: "JetBrainsMono Nerd Font", "DejaVu Sans Mono", sans-serif;
      font-size: 14px;
    }

    /* Ne mets pas min-height:0 globalement si tu veux éviter la barre “fil de fer”. */
    window#waybar { background: transparent; }

    .modules-left,
    .modules-center,
    .modules-right {
      background-color: alpha(@theme_bg_color, 0.75);
      border: 1px solid alpha(@theme_fg_color, 0.10);
      border-radius: 16px;
      padding: 8px 12px;
    }

    #workspaces button {
      padding: 4px 10px;
      margin: 0 4px;
      border-radius: 999px;
      background: transparent;
      border: 1px solid transparent;
      transition: 120ms ease-in-out;
    }

    #workspaces button:hover {
      background-color: alpha(@theme_fg_color, 0.08);
      border-color: alpha(@theme_fg_color, 0.10);
    }

    #workspaces button.focused {
      background-color: alpha(@theme_selected_bg_color, 0.35);
      color: @theme_selected_fg_color;
      border-color: alpha(@theme_selected_bg_color, 0.55);
    }

    #tray, #network, #pulseaudio, #cpu, #memory, #temperature, #battery, #clock, #idle_inhibitor, #mode, #window {
      padding: 4px 10px;
      border-radius: 999px;
      background-color: alpha(@theme_fg_color, 0.06);
      border: 1px solid alpha(@theme_fg_color, 0.08);
    }

    tooltip {
      background-color: alpha(@theme_bg_color, 0.92);
      border: 1px solid alpha(@theme_fg_color, 0.12);
      border-radius: 12px;
      padding: 8px 10px;
    }
  '';
};
}
