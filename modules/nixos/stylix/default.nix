# modules/nixos/stylix/default.nix
{ pkgs, userName, ... }:
{
    stylix.enable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    #stylix.image = pkgs.fetchurl {
    #    url = "https://raw.githubusercontent.com/orangci/walls-catppuccin-mocha/refs/heads/master/basement.jpg";
    #    hash = "sha256-rXH2iOtJVreFDUQHLk//io6EzfwiyzDW8k66EspIVds=";
    #};
}