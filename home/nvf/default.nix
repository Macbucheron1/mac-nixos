{ osConfig ? null, config, pkgs, codex-nvim ? null, ... }:
{
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = import ./vim-settings.nix {
      inherit osConfig config pkgs codex-nvim;
    };
  };
}
