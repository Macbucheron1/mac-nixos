{ config, pkgs, lib, ... }:

{
  home.username = "mac";
  home.homeDirectory = "/home/mac";
  home.stateVersion = "25.11";
  programs.home-manager.enable = true;

  dconf.settings = {
    "org/gnome/desktop/input-sources" = {
      sources = [
        (lib.hm.gvariant.mkTuple [ "xkb" "fr" ])
      ];
      xkb-options = [ ];
    };
    "org/gnome/system/locale" = {
      region = "fr_FR.UTF-8";
    };
  };

  home.sessionVariables = {
    LANG = "fr_FR.UTF-8";
    LC_ALL = "fr_FR.UTF-8";
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


}

