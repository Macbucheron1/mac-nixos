{ pkgs, ... }:
{
    stylix = {
        enable = true;
        polarity = "dark";

        # Gruvbox theme
        base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
        image = ./../wallpapers/gruvbox_linux.png;

        # Catppuccin theme
        # base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
        # image = ./../../../wallpapers/catppuccin_basement.png;

    };
}