{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    defaultEditor = true;
    viAlias = true;
    vimAlias = true;

    sideloadInitLua = true;

    extraPackages = with pkgs; [
      go
      gcc
      tree-sitter
      gnumake
      cmake
      ripgrep
      fd
    ];
  };
}
