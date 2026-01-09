{...}:
{
programs.i3status-rust = {
  enable = true;

  bars.default = {
    theme = "plain";      # laisse Stylix gérer les couleurs :contentReference[oaicite:13]{index=13}
    icons = "material-nf"; # ou "awesome6" selon tes goûts :contentReference[oaicite:14]{index=14}

    settings = {
      # Force une police icônes + ajoute un padding visuel cohérent
      icons_format = " <span font_family='JetBrainsMono Nerd Font'>{icon}</span> ";
    };

    blocks = [
      {
        block = "focused_window";
        format = " $title.str(max_w:48) ";
      }

      { block = "cpu"; interval = 1; format = " $icon $utilization.eng(w:2) "; }
      { block = "memory"; format = " $icon $mem_used_percents.eng(w:2) "; }
      { block = "disk_space"; path = "/"; info_type = "available"; interval = 60;
        format = " $icon $available.eng(w:2) "; warning = 20.0; alert = 10.0;
      }

      { block = "net"; interval = 3;
        format = " $icon $device {$ssid |$ip} ";
        format_alt = " $icon $speed_down.eng(w:2)↓ $speed_up.eng(w:2)↑ ";
      }

      { block = "sound";
        format = " $icon {$volume.eng(w:2) |muted} ";
        click = [{ button = "left"; cmd = "pavucontrol"; }];
      }

      { block = "battery";
        format = " $icon $percentage $time ";
        interval = 30;
      }

      { block = "time";
        interval = 10;
        format = " $icon $timestamp.datetime(f:'%a %d/%m %R') ";
      }
    ];
  };
};
}
