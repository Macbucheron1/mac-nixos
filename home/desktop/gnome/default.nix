
{ config, lib, pkgs, ... }:
{
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
      };

      "org/gnome/desktop/interface" = {
        cursor-theme = "Adwaita";  
        icon-theme   = "Adwaita";
      };

      "org/gnome/desktop/peripherals/keyboard" = {
        numlock-state = true;
        remember-numlock-state = true;
      };
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