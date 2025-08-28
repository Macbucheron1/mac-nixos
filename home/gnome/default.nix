
{ config, lib, ... }:
{
  home.file."Pictures/wallpapers/nix-dark.png".source = ./../../wallpapers/nix-dark.png;
  home.file."Pictures/wallpapers/nix-bright.png".source = ./../../wallpapers/nix-bright.png;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";     
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "fr" ]) ];
      xkb-options = [ ];
    };

    "org/gnome/desktop/background" = {
      picture-uri = "file://${config.home.homeDirectory}/Pictures/wallpapers/nix-bright.png";
      picture-uri-dark = "file://${config.home.homeDirectory}/Pictures/wallpapers/nix-dark.png";
      picture-options = "zoom";  # alternatives: centered|scaled|stretched|spanned|wallpaper
    };

    "org/gnome/desktop/screensaver" = {
      picture-uri = "file://${config.home.homeDirectory}/Pictures/wallpapers/nix-dark.png";
      picture-options = "zoom";
    };

    "org/gnome/system/locale" = {
      region = "en_US.UTF-8";
    };

    "org/gnome/shell" = {
      # Ordre = gauche → droite dans le dock
      favorite-apps = [
        "code.desktop"
        "firefox.desktop"
        "discord.desktop"
        "obsidian.desktop"
      ];
    };
  };
}