{ pkgs, lib }:
let
  path = lib.makeBinPath [
    pkgs.udiskie
    pkgs.udisks2
    pkgs.jq
    pkgs.util-linux
    pkgs.psmisc
    pkgs.coreutils
    pkgs.bash
    pkgs.cliphist
    pkgs.foot
    pkgs.fzf
    pkgs.gnugrep
    pkgs.gnused
    pkgs.gawk
    pkgs.rofi
    pkgs.libnotify
    pkgs.sway
    pkgs.wl-clipboard
    pkgs.wtype
  ];

  mk = name: src:
    pkgs.writeShellScriptBin name (
      builtins.replaceStrings
        [ "@PATH@" ]
        [ path ]
        (builtins.readFile src)
    );
in
{
  ejectUsb = mk "rofi-eject-external" ./eject-usb.sh;
  smartClipboard = mk "smart-clipboard" ./smart-clipboard.sh;
}
