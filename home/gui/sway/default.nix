{ pkgs, lib, config, ... }:
let 
  volumeScript = ./script/volume-notify.sh;
  brightScript = ./script/brightness-notify.sh;
  micScript = ./script/mic-toggle.sh;
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      startup = [
        { command = "foot"; }
      ];
      defaultWorkspace = "workspace number 1";
      input."*".xkb_layout = "fr";
      keybindings = lib.mkOptionDefault {
        # Launcher
        "${modifier}+p" = "exec rofi -show drun"; 

        # Screenshot
        "Print" = "exec grim -g \"$(slurp)\" - | wl-copy";

        # Audio settings
        "XF86AudioMute" = "exec bash ${volumeScript} mute";
        "XF86AudioRaiseVolume" = "exec bash ${volumeScript} up";
        "XF86AudioLowerVolume" = "exec bash ${volumeScript} down";

        # Brightness settings
        "XF86MonBrightnessDown" = "exec bash ${brightScript} down";
        "XF86MonBrightnessUp" = "exec bash ${brightScript} up";

        # Mic Settings 
        "XF86AudioMicMute" = "exec bash ${micScript}";

        # Lock
        "${modifier}+Shift+l" = "exec ${config.home.profileDirectory}/bin/lockscreen";

        # Workspace
        "${modifier}+ampersand"  = "workspace number 1";
        "${modifier}+eacute"     = "workspace number 2";
        "${modifier}+quotedbl"   = "workspace number 3";
        "${modifier}+apostrophe" = "workspace number 4";
        "${modifier}+parenleft"  = "workspace number 5";
        "${modifier}+minus"      = "workspace number 6";
        "${modifier}+egrave"     = "workspace number 7";
        "${modifier}+underscore" = "workspace number 8";
        "${modifier}+ccedilla"   = "workspace number 9";
        "${modifier}+agrave"     = "workspace number 10";

        # Workspace moving
        "${modifier}+Shift+ampersand"  = "move container to workspace number 1";
        "${modifier}+Shift+eacute"     = "move container to workspace number 2";
        "${modifier}+Shift+quotedbl"   = "move container to workspace number 3";
        "${modifier}+Shift+apostrophe" = "move container to workspace number 4";
        "${modifier}+Shift+parenleft"  = "move container to workspace number 5";
        "${modifier}+Shift+minus"      = "move container to workspace number 6";
        "${modifier}+Shift+egrave"     = "move container to workspace number 7";
        "${modifier}+Shift+underscore" = "move container to workspace number 8";
        "${modifier}+Shift+ccedilla"   = "move container to workspace number 9";
        "${modifier}+Shift+agrave"     = "move container to workspace number 10";
      };
      # bars = [
      #   {
      #     fonts = {
      #       names = [ "DejaVu Sans Mono" ];
      #       size = 14.0;
      #     };
      #
      #     statusCommand = "${pkgs.i3status}/bin/i3status";
      #
      #     position = "bottom";
      #     workspaceButtons = true;
      #     workspaceNumbers = true;
      #     trayOutput = "primary";
      #   }
      # ];

      bars = [
        {
          id = "bar-main";
          command = "swaybar";

          position = "bottom";
          mode = "dock";

          fonts = {
            names = [
              "DejaVu Sans Mono"
              # Recommandé pour les icônes (Nerd Font)
              "JetBrainsMono Nerd Font"
            ];
            size = 14.0;
          };

          # i3status-rs (voir section 2)
          statusCommand = "${pkgs.i3status-rust}/bin/i3status-rs ~/.config/i3status-rust/config-default.toml";

          workspaceButtons = true;
          workspaceNumbers = true;

          trayOutput = "*";     # swaybar: none|<output>|* :contentReference[oaicite:3]{index=3}
          trayPadding = 4;      # padding autour/entre icônes :contentReference[oaicite:4]{index=4}

          extraConfig = ''
            # Barre plus “épaisse” + un peu décollée du bord
            height 32
            gaps 8 10

            # Status: respiration / alignements
            status_padding 3
            status_edge_padding 10

            # Workspaces: rendu plus régulier + scroll circulaire
            workspace_min_width 36
            wrap_scroll yes

            # Séparateurs plus stylés que "|"
            separator_symbol "  "

            # Support multi-écrans (optionnel : commente si inutile)
            output *
          '';
        }
      ];
    };
    extraConfig = ''
      # No titlebar, keep a 1px border
      default_border pixel 1
      default_floating_border pixel 1
    '';

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };

  # https://wiki.nixos.org/wiki/Sway
  # It's recommended to enable a Secret Service provider, like GNOME Keyring
  services.gnome-keyring.enable = true;
  imports = [ ./swaylock.nix ./swayidle.nix ];
}
