{ pkgs, lib, config, ... }:
let 
  scripts = import ./scripts { inherit pkgs lib; };
in
{
  wayland.windowManager.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    config = rec {
      modifier = "Mod4";
      terminal = "foot";
      startup = [
        { command = "exec ${pkgs.foot}/bin/foot -a btop -e ${pkgs.btop}/bin/btop"; }
      ];
      assigns = {
        "10" = [ { app_id = "^btop$"; } ];
      };
      defaultWorkspace = "1";
      input."*" = {
        xkb_layout = "fr";
        xkb_options = "caps:escape";
      };
      keybindings = lib.mkOptionDefault {
        # Launcher
        "${modifier}+d" = "exec ${pkgs.rofi}/bin/rofi -show drun";
        "${modifier}+Shift+e" = "exec ${scripts.ejectUsb}/bin/rofi-eject-external";

        # Screenshot
        "Print" = "exec ${pkgs.grim}/bin/grim -g \"$(slurp)\" - | ${pkgs.wl-clipboard}/bin/wl-copy";

        # Audio settings
        "XF86AudioMute" = "exec ${pkgs.avizo}/bin/volumectl toggle-mute";
        "XF86AudioRaiseVolume" = "exec ${pkgs.avizo}/bin/volumectl up";
        "XF86AudioLowerVolume" = "exec ${pkgs.avizo}/bin/volumectl down";

        # Brightness settings
        "XF86MonBrightnessDown" = "exec ${pkgs.avizo}/bin/lightctl down";
        "XF86MonBrightnessUp" = "exec ${pkgs.avizo}/bin/lightctl up";

        # Mic Settings 
        "XF86AudioMicMute" = "exec ${pkgs.avizo}/bin/volumectl -m toggle-mute";

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
      bars = [
        {
          command = "${pkgs.waybar}/bin/waybar";
          position = "bottom";
        }
      ];
    };
    extraConfig = ''
      default_border pixel 1
      default_floating_border pixel 1

      set $laptop eDP-1 
      bindswitch --reload --locked lid:on output $laptop disable
      bindswitch --reload --locked lid:off output $laptop enable
    '';

    systemd = {
      enable = true;
      variables = [ "--all" ];
    };
  };

  # https://wiki.nixos.org/wiki/Sway
  # It's recommended to enable a Secret Service provider, like GNOME Keyring
  services.gnome-keyring.enable = true;
  imports = [ ./swaylock.nix ./swayidle.nix ./kanshi.nix ];
}
