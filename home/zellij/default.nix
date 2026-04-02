{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    enableBashIntegration = true;
    attachExistingSession = true;
    settings.theme = "default";

    extraConfig = ''
      keybinds {
        normal {
          bind "Ctrl y" {
            Run "${pkgs.bash}/bin/bash" "-c" "${pkgs.cliphist}/bin/cliphist list | ${pkgs.fzf}/bin/fzf | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy" {
              floating true
              close_on_exit true
            }
          }
        }
      }
    '';
  };
}
