{ pkgs, ... }:
{
  # Adds an entry to roff drun
  xdg.desktopEntries.nmtui = {
    name = "nmtui";
    comment = "NetworkManager TUI";
    type = "Application";
    terminal = false;
    categories = [ "System" "Network" ];
    exec = "${pkgs.foot}/bin/foot -e ${pkgs.networkmanager}/bin/nmtui";
    icon = ./icon/wifi.png;
  };

  xdg.desktopEntries.bluetui ={
    name = "bluetui";
    comment = "Bluetooth manager TUI";
    type = "Application";
    terminal = false;
    categories = [ "System" "Network" ];
    exec = "${pkgs.foot}/bin/foot -e ${pkgs.bluetui}/bin/bluetui";
    icon = ./icon/bluetooth.png;
  };

  xdg.desktopEntries.btop = {
      name = "btop++";
      comment = "Btop++";
      type = "Application";
      terminal = true;
      categories = [ "System" ];
      exec = "${pkgs.foot}/bin/foot -e ${pkgs.btop}/bin/btop";
      icon = "btop";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;
    desktop     = "$HOME/Desktop";
    download    = "$HOME/Downloads";  
    documents   = "$HOME/Documents";
    music       = "$HOME/Music";
    pictures    = "$HOME/Pictures";
    videos      = "$HOME/Videos";
    publicShare = "$HOME/Public";
    templates   = "$HOME/Templates";
  };

  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
      xdg-desktop-portal-termfilechooser
    ];
    config = {
      sway = {
        default = [ "wlr" "gtk" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "termfilechooser" ];
      };
      common.default = [ "*" ];
    };
  };


  xdg.configFile."xdg-desktop-portal-termfilechooser/config".text = ''
    [filechooser]
    cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    default_dir=$HOME

    # Terminal utilisé pour afficher Yazi (adapte à ton terminal)
    env=TERMCMD='foot -T "file chooser"'

    open_mode=suggested
    save_mode=last
  '';
}
