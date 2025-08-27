{ config, lib, pkgs, ... }:

let
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
  # VS Code (User scope) – Linux
  xdg.configFile."Code/User/mcp.json".text = builtins.toJSON mcpCfg;

  # (Recommandé) Active l’auto-découverte des MCP déjà déclarés ailleurs
  programs.vscode.userSettings."chat.mcp.discovery.enabled" = true;
}
