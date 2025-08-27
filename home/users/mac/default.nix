{ config, pkgs, lib, ... }:

{
  home.username = "mac";
  home.homeDirectory = "/home/mac";
  home.stateVersion = "25.11";
  home.file."Pictures/wallpapers/nix-dark.png".source = ./wallpapers/nix-dark.png;
  home.file."Pictures/wallpapers/nix-bright.png".source = ./wallpapers/nix-bright.png;
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";     
    };

    "org/gnome/desktop/input-sources" = {
      sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "fr" ]) ];
      xkb-options = [ ];
    };

    "org/gnome/desktop/background" = {
      # IMPORTANT GNOME 42+ : light vs dark
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
        "firefox.desktop"
        "code.desktop"        # VS Code (VSCodium = "codium.desktop")
        "discord.desktop"
      ];
    };
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



  programs.vscode = {
    enable = true;
    package = pkgs.vscode;
    profiles.default = {
      extensions = with pkgs.vscode-extensions; [
        catppuccin.catppuccin-vsc
        bbenoist.nix
        pkief.material-icon-theme
        esbenp.prettier-vscode
        github.copilot
        github.copilot-chat
      ];
      userSettings = {
        "workbench.colorTheme" = "Catppuccin Mocha";
        "workbench.iconTheme"  = "material-icon-theme";
        "files.autoSave" = "afterDelay";
        "github.copilot.enable.*" = true;
        "git.enableSmartCommit" =  true;
        "git.autofetch" = true;
        "git.confirmSync" = false;
        "explorer.confirmDragAndDrop" = false;
      };
    };
  };

  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    userName  = "macbucheron";
    userEmail = "nathandeprat@hotmail.fr";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  imports = [
    ./../../vscode/default.nix
  ];
}

