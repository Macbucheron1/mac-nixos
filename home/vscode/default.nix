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

  vscodeSettings = {
    "workbench.iconTheme" = "material-icon-theme";
    "files.autoSave" = "afterDelay";
    "github.copilot.enable.*" = true;

    "git.enableSmartCommit" = true;
    "git.autofetch" = true;
    "git.confirmSync" = false;

    "explorer.confirmDragAndDrop" = false;

    "chat.mcp.discovery.enabled" = {
      "claude-desktop" = true;
      "windsurf" = true;
      "cursor-global" = true;
      "cursor-workspace" = true;
    };

    "python.languageServer" = "Pylance";

    "terminal.integrated.profiles.linux.nixos-bash.path" = "/run/current-system/sw/bin/bash";
    "terminal.integrated.defaultProfile.linux" = "nixos-bash";
  };
in
{
  home.packages = lib.mkAfter [
    pkgs.vscode.fhs
  ];

  xdg.configFile."Code/User/settings.json".text = builtins.toJSON vscodeSettings;
  xdg.configFile."Code/User/mcp.json".text      = builtins.toJSON mcpCfg;
}