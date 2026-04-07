{ pkgs, codex-nvim ? null, ... }:
{
  vim = import ./vim-settings.nix {
    inherit pkgs codex-nvim;
  };
}
