{ pkgs, ... }:
let
  # Vibe coded do not touch
  applyProfile = pkgs.writeShellScript "kanshi-apply-profile" ''
    set -euo pipefail

    PROFILE="$1"

    # Wait until Sway IPC is ready
    for i in $(seq 1 100); do
      swaymsg -t get_version >/dev/null 2>&1 && break
    done

    has_app() {
      swaymsg -t get_tree \
        | ${pkgs.jq}/bin/jq -e --arg id "$1" '..|objects|select(.app_id?==$id)' >/dev/null
    }

    start_if_missing() {
      local appid="$1"
      shift
      if ! has_app "$appid"; then
        "$@"
      fi
    }

    if [ "$PROFILE" = "laptop" ]; then
      # Outputs/workspaces on eDP
      swaymsg 'workspace 1, move workspace to output eDP-1, workspace 2, move workspace to output eDP-1, workspace 3, move workspace to output eDP-1'

      # Start apps on the right workspaces (only if missing)
      start_if_missing mainterm swaymsg 'workspace 1; exec ${pkgs.foot}/bin/foot -a mainterm'
      start_if_missing firefox  swaymsg 'workspace 2; exec ${pkgs.firefox}/bin/firefox'

      # Now handle workspace 10 last (so it doesn't steal new windows)
      swaymsg 'workspace 10, move workspace to output eDP-1, workspace 1'

    elif [ "$PROFILE" = "home" ]; then
      # Place workspaces on the right outputs
      swaymsg 'workspace 1, move workspace to output HDMI-A-1, workspace 2, move workspace to output DP-1, workspace 10, move workspace to output eDP-1'

      # Start apps on the right workspaces (only if missing)
      start_if_missing firefox  swaymsg 'workspace 1; exec ${pkgs.firefox}/bin/firefox'
      start_if_missing mainterm swaymsg 'workspace 2; exec ${pkgs.foot}/bin/foot -a mainterm'

      # Workspace 10 last
      swaymsg 'workspace 10 move workspace to output eDP-1, workspace 1'
    fi
  '';
in
{
  services.kanshi = {
    enable = true;
    settings = [
      {
        profile = {
          name = "laptop";
          outputs = [
            { criteria = "eDP-1"; status = "enable"; }
          ];
          exec = "${applyProfile} laptop";
        };
      }
      {
        profile = {
          name = "home";
          outputs = [
            { criteria = "HDMI-A-1"; status = "enable"; position = "0,0"; }
            { criteria = "DP-1";     status = "enable"; position = "1920,0"; }
            { criteria = "eDP-1";    status = "enable"; position = "3840,0"; }
          ];
          exec = "${applyProfile} home";
        };
      }
    ];
  };
}

