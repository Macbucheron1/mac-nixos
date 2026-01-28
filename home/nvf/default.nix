{ osConfig ? null, config, ... }:
{
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = import ./vim-settings.nix {
      inherit osConfig config;
    };
  };
}

