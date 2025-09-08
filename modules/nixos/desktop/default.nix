# modules/nixos/desktop/default.nix
{ lib, desktopType ? "none", ... }:
{
  imports =
    [ ]
    ++ lib.optionals (desktopType == "gnome")  [ ./gnome ];
}
