{ ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    waylandSupport = true;
    extraLuaConfig = ''
    	vim.opt.clipboard = "unnamedplus"
    ''
  };
}
