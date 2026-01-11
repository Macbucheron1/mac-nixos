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

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.fira-code;
        name = "FiraCode Nerd Font";
      };

      sansSerif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Sans";
      };

      serif = {
        package = pkgs.dejavu_fonts;
        name = "DejaVu Serif";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 15;
        desktop = 15;
        popups = 15;
        terminal = 15;
      };
    };
  };
}

