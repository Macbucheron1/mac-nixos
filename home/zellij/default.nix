{ pkgs, ... }:
{
  programs.zellij = {
    enable = true;
    settings.theme = "default";
    settings = {
      show_startup_tips = false;
    };

    extraConfig = ''
      plugins {
        smart-tabs location="file:${pkgs.fetchurl {
          url = "https://github.com/YesYouKenSpace/zellij-smart-tabs/releases/download/v0.1.0/zellij-smart-tabs.wasm";
          sha256 = "sha256-UCm//MubmJaapzmct8utONj4L1xGrdA3lgima7tPXUU=";
        }}" {
          sub {
            program {
              bash ""
            }
          }
          poll_interval 1
        }
      }

      load_plugins {
        smart-tabs
      }

      keybinds {
        normal {
          bind "Ctrl y" {
            Run "${pkgs.bash}/bin/bash" "-c" "${pkgs.cliphist}/bin/cliphist list | ${pkgs.fzf}/bin/fzf --reverse | ${pkgs.cliphist}/bin/cliphist decode | ${pkgs.wl-clipboard}/bin/wl-copy" {
              floating true
              close_on_exit true
            }
          }
        }
      }
    '';
  };
}
