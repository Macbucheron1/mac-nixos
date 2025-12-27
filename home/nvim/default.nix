{ ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    waylandSupport = true;
    extraLuaConfig = ''
    	vim.opt.clipboard = "unnamedplus"

	-- Indentation is now 2 space
	vim.opt.tabstop = 2
	vim.opt.shiftwidth = 2;
	vim.opt.expandtab = true;
	vim.opt.smartindent = true;
    '';
  };
}
