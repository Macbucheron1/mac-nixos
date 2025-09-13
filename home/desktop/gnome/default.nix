
{ config, lib, pkgs, ... }:
{

  home.packages = with pkgs.gnomeExtensions; [
    logo-menu
    blur-my-shell
    open-bar
    rounded-window-corners-reborn
    space-bar
    tophat
  ];

  dconf = {
    enable = true;
    settings = {

      "org/gnome/desktop/input-sources" = {
        sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "fr" ]) ];
        xkb-options = [ ];
      };

      "org/gnome/system/locale" = {
        region = "en_US.UTF-8";
      };

      "org/gnome/shell" = {
        # Ordre = gauche → droite dans le dock
        favorite-apps = [
          "code.desktop"
          "firefox.desktop"
          "obsidian.desktop"
          "vesktop.desktop"
          "org.gnome.Nautilus.desktop"
          "Alacritty.desktop"
        ];
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          logo-menu.extensionUuid
          blur-my-shell.extensionUuid
          open-bar.extensionUuid
          rounded-window-corners-reborn.extensionUuid
          space-bar.extensionUuid
          tophat.extensionUuid
        ];
      };

      "org/gnome/desktop/interface" = {
        cursor-theme = "Adwaita";  
        icon-theme   = "Adwaita";
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
        remember-numlock-state = true;
      };

      "org/gnome/shell/extensions/Logo-menu" = {
        menu-button-icon-image = 23;
      };

      "org/gnome/shell/extensions/blur-my-shell" = {
        settings-version = 2;
      };

      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        blur = false;
        brightness = 0.0;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/coverflow-alt-tab" = {
        settings-version = 2;
        pipeline = "pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur=false;
        brightness=0.59999999999999998;
        pipeline="pipeline_default_rounded";
        sigma=30;
        static-blur=true;
        style-dash-to-dock=0;
      };

      "org/gnome/shell/extensions/blur-my-shell/lockscreen" = {
        pipeline="pipeline_default";
      };

      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        blur=true;
        pipeline="pipeline_default";
        style-components=0;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        blur=false;
        brightness=0.59999999999999998;
        pipeline="pipeline_default";
        sigma=30;
      };

      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        pipeline="pipeline_default";
      };
      
      "org/gnome/shell/extensions/blur-my-shell/screenshot" = {
        brightness=0.59999999999999998;
        sigma=30;
      };

      "org/gnome/shell/extensions/rounded-window-corners-reborn" = {
        "border-width" = 0;
        "skip-libadwaita-app" = false;
        "skip-libhandy-app"   = false;

        "global-rounded-corner-settings" = lib.hm.gvariant.mkVariant
          "{'padding': <{'left': uint32 1, 'right': 1, 'top': 1, 'bottom': 1}>, 'keepRoundedCorners': <{'maximized': true, 'fullscreen': false}>, 'borderRadius': <uint32 12>, 'smoothing': <0.4>, 'borderColor': <(0.5, 0.5, 0.5, 1.0)>, 'enabled': <true>}";

        "settings-version" = lib.hm.gvariant.mkUint32 7;
      };

      "org/gnome/shell/extensions/tophat" = {
        "cpu-display" = "numeric";
        "cpu-normalize-proc-use" = true;
        "cpu-show-cores" = false;
        "fs-display" = "numeric";
        "fs-hide-in-menu" = "";
        "group-procs" = true;
        "mem-display" = "numeric";
        "mount-to-monitor" = "/";
        "network-usage-unit" = "bytes";
        "refresh-rate" = "slow";
        "show-cpu" = true;
        "show-disk" = false;
        "show-fs" = true;
        "show-menu-actions" = true;
      };

      "org/gnome/shell/extensions/space-bar/behavior" = {
        "indicator-style" = "workspaces-bar";
        position = "left";
        "scroll-wheel" = "panel";
        "show-empty-workspaces" = true;
        "smart-workspace-names" = true;
        "toggle-overview" = true;
      };

      "org/gnome/shell/extensions/space-bar/state" = {
        version = 33;
        "workspace-names-map" = ''{"firefox":["Code"],"Code":["Code"]}'';
      };

      "org/gnome/shell/extensions/space-bar/appearance" = import ./extensions/space-bar-appareance.nix;

      "org/gnome/shell/extensions/openbar" = import ./extensions/openbar.nix;
    };
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Adwaita";
      package = pkgs.adwaita-icon-theme;
    };
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = "org.gnome.Nautilus.desktop";
      "application/x-directory" = "org.gnome.Nautilus.desktop";
      "image/*" = "org.gnome.Shotwell.desktop";
      "video/*" = "io.github.celluloid_player.desktop";
      "audio/*" = "org.gnome.Rhythmbox3.desktop";
    }; 
  };
  
  systemd.user.services.alacritty-autostart = {
    Unit = {
      Description = "Launch Alacritty after GNOME session settles";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${pkgs.alacritty}/bin/alacritty";
      Restart = "on-failure";
    };
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}