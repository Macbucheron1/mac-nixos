{ pkgs, config, ... }:
let
  lockscreen = pkgs.writeShellApplication {
    name = "lockscreen";
    runtimeInputs = [
      pkgs.grim
      pkgs.imagemagick
      config.programs.swaylock.package
      pkgs.coreutils
    ];
    text = ''
      #!/usr/bin/env bash
      set -euo pipefail

      tmp_dir="''${XDG_RUNTIME_DIR:-/tmp}"
      src="$(mktemp "$tmp_dir/lock_src.XXXXXX.ppm")"
      pix="$(mktemp "$tmp_dir/lock_pix.XXXXXX.ppm")"
      trap 'rm -f "$src" "$pix"' EXIT

      PIX="5%"

      grim -t ppm "$src"

      convert "$src" \
        -filter point -resize "$PIX" -resize 1000% \
        "$pix"

      exec swaylock --daemonize -i "$pix"
    '';
  };

  lock = "${lockscreen}/bin/lockscreen";
  display = status: "${pkgs.sway}/bin/swaymsg 'output * power ${status}'";
in
{
  home.packages = [ lockscreen ];

  services.swayidle =
  {
    enable = true;

    timeouts = [
      {
        timeout = 290;
        command = "${pkgs.libnotify}/bin/notify-send 'Locking in 10 seconds' -t 5000";
      }
      {
        timeout = 300;
        command = lock;
      }
      {
        timeout = 450;
        command = display "off";
        resumeCommand = display "on";
      }
      {
        timeout = 600;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];

    events = {
      "before-sleep" = (display "off") + "; " + lock;
      "after-resume" = display "on";
      "lock"         = (display "off") + "; " + lock;
      "unlock"       = display "on";
    };
  };
}

