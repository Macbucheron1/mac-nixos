{ pkgs, nvf, codex-nvim, ... }:
(nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [
    {
      _module.args = {
        inherit codex-nvim;
      };
    }
    ./../home/nvf/nvf-module.nix
  ];
}).neovim
