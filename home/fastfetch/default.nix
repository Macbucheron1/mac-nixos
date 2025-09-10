{ config, lib, pkgs, ... }:
let
  c = config.lib.stylix.colors.withHashtag;
  strip = hex: lib.removePrefix "#" hex;
  block = hex: "{##${strip hex}}██{#}";
  line = hexes: lib.concatStrings (map block hexes);

  line1 = line [ c.base00 c.base01 c.base02 c.base03 c.base04 c.base05 c.base06 c.base07 ];
  line2 = line [ c.base08 c.base09 c.base0A c.base0B c.base0C c.base0D c.base0E c.base0F ];
in
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        type = "builtin";
        source = "nixos";   # gros logo
        padding = { right = 2; };
        color = { "1" = c.base0D; "2" = c.base0B; "3" = c.base09; };
      };

      display = {
        color = { keys = c.base0D; title = c.base0E; separator = c.base04; };
        key = { width = 12; };
      };

      modules = [
        "title"
        "separator"
        { type = "os";       key = "OS"; }
        { type = "kernel";   key = "Kernel"; }
        { type = "uptime";   key = "Uptime"; }
        { type = "shell";    key = "Shell"; }
        { type = "wm";       key = "WM"; }
        { type = "terminal"; key = "Term"; }
        { type = "memory";   key = "Memory"; percent = { type = 3; }; }
        { type = "cpu";      key = "CPU"; }
        { type = "gpu";      key = "GPU"; }
        { type = "disk";     key = "Disk"; path = "/"; }
        { type = "battery";  key = "Battery"; }
      ];
    };
  };
}
