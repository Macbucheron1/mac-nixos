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

    plugins = {
      lsp = {
        enable = true;
        servers = {
          nixd.enable = true;
        };
      };
    };
  };
}
