
{ config, lib, ... }:
{
  dconf.settings = {

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