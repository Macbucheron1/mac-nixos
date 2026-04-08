{ pkgs, ... }:
let 
  myCustomPkgs = import ../../pkgs { inherit pkgs; };
in 
{
  programs.codex = {
    enable = true;

    settings.mcp_servers = {
      exegol = {
        type = "stdio";
        command = "${myCustomPkgs.exegol-mcp}/bin/exegol-mcp";
        args = [ "-t" "stdio" ];
      };

      github = {
        type = "http";
        url = "https://api.githubcopilot.com/mcp/";
      };

      nixos = {
        type = "stdio";
        command = "nix";
        args = [ "run" "github:utensils/mcp-nixos" "--" ];
      };

      wiremcp = {
        type = "stdio";
        command = "${myCustomPkgs.wiremcp}/bin/wiremcp";
      };

      burp = {
        type = "stdio";
        command = "${pkgs.mcp-proxy}/bin/mcp-proxy";
        args = [ "http://127.0.0.1:9876" ];
      };
    };
  };
}
