# modules/nixos/desktop/default.nix
{ lib, desktopType ? "none", ... }:
{
  imports =
    [ ]
    ++ lib.optionals (desktopType == "gnome")  [ ./gnome ]
    ++ lib.optionals (desktopType == "plasma") [ ./plasma ]
    ++ lib.optionals (desktopType == "none") [ ./none ];
}
