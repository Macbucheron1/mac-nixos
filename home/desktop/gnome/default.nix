
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
}