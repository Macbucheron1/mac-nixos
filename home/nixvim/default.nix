# home/nixvim/default.nix
{ ... }:
{
  programs.nixvim = {
    enable = true;
    defaultEditor = true;
    waylandSupport = true; 
    impureRtp = false;

    opts = {
      clipboard = "unnamedplus";

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;
    };
  };
}
