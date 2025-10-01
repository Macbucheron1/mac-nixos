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
      mutableExtensionsDir = false;
      profiles.default = {
        extensions = with pkgs.vscode-extensions; [
          bbenoist.nix
          pkief.material-icon-theme
          esbenp.prettier-vscode
          github.copilot
          github.copilot-chat

          # C & C++ tools
          twxs.cmake
          ms-vscode.cpptools


          # Python tools
          ms-python.python
          ms-toolsai.jupyter
          ms-python.vscode-pylance
        ];
        userSettings = {
          "workbench.iconTheme"  = lib.mkForce "material-icon-theme";
          "files.autoSave" = "afterDelay";
          "github.copilot.enable.*" = true;
          "git.enableSmartCommit" =  true;
          "git.autofetch" = true;
          "git.confirmSync" = false;
          "explorer.confirmDragAndDrop" = false;
          "chat.mcp.discovery.enabled" = true;
          "python.languageServer" = "Pylance";
        };
      };
    };

  xdg.configFile."Code/User/mcp.json".text = builtins.toJSON mcpCfg;
}
