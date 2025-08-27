{ config, lib, pkgs, ... }:

let

  # Définition du serveur mcp nix pour VS Code
  # https://github.com/utensils/mcp-nixos
  mcpCfg = {
    servers = {
      nixos = {
        type = "stdio";
        command = "nix";
        args = [ "run" "github:utensils/mcp-nixos" "--" ];
      };
    };
  };
in {
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
        "chat.mcp.discovery.enabled" = true;
      };
    };
  };

  xdg.configFile."Code/User/mcp.json".text = builtins.toJSON mcpCfg;
}
