{ pkgs, nvf, ... }:
(nvf.lib.neovimConfiguration {
  inherit pkgs;
  modules = [ ./../home/nvf/nvf-module.nix ];
}).neovim

