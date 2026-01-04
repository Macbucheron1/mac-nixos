{ config, osConfig, lib, ... }:
let
  # Path where the flake of the configuration is located
  flakePath = "~/Documents/mac-nixos/"; 
  flakeExpr = ''(builtins.getFlake "${flakePath}")'';

  # Is a nixosConfigurations or just home-manager
  hasOsConfig = osConfig != null;

  # Hostname needed only if building a nixosConfigurations
  host =
    if hasOsConfig
    then osConfig.networking.hostName
    else "lenovo-legion"; # Change to the hostname if not on nixos

  nixosOpts = "${flakeExpr}.nixosConfigurations.${host}.options";
in
{
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = {

      theme = {
        enable = true;
        name = "gruvbox";
        style = "dark";
      };

      # vi & vim launches neovim
      viAlias = true;
      vimAlias = true;

      options = {
        tabstop = 2;
        shiftwidth = 2;
      };

      # neovim use the system register by default
      clipboard = {
        enable = true;
        registers = "unnamedplus";
      };

      languages = {
        enableTreesitter = true;
        nix = {
          enable = true;
          lsp.servers = [ "nixd" ];
        };
      };

      lsp = {
        enable = true;

        servers.nixd = {
          enable = true;

          init_options = {
            nixpkgs = {
              expr = "import ${flakeExpr}.inputs.nixpkgs { }";
            };

            # nixosConfigurations or home-manager ?
            options =
              (lib.optionalAttrs hasOsConfig {
                nixos = {
                  expr = nixosOpts;
                };
              })
              // {
                "home-manager" = {
                  expr = "${nixosOpts}.home-manager.users.type.getSubOptions []";
                };
              };
          };
        };
      };

      statusline.lualine.enable = true;           # https://github.com/nvim-lualine/lualine.nvim
      autocomplete.blink-cmp.enable = true;       # https://github.com/hrsh7th/nvim-cmp
      git.vim-fugitive.enable = true;             # https://github.com/tpope/vim-fugitive
      visuals.indent-blankline.enable = true;     # https://github.com/lukas-reineke/indent-blankline.nvim
      visuals.rainbow-delimiters.enable = true;   # https://github.com/HiPhish/rainbow-delimiters.nvim

      tabline.nvimBufferline = {                  # https://github.com/akinsho/bufferline.nvim
        enable = true;
        setupOpts.options = {
          numbers = "none";
          indicator.style = "none";
        };
      };

      utility.motion.leap.enable = true;           # https://codeberg.org/andyg/leap.nvim

      utility.oil-nvim = {                         # https://github.com/stevearc/oil.nvim
        enable = true;
        gitStatus.enable = true;
      };

      telescope = {                                # https://github.com/nvim-telescope/telescope.nvim
        enable = true;
        mappings = {
          findFiles = "ff";
          liveGrep = "fg";
        };
      };

      binds.whichKey = {                           # https://github.com/folke/which-key.nvim
        enable = true;
        register = {
          "<leader>f" = "+Telescope";
          "<leader>ff" = "Find file";
          "<leader>fg" = "Live grep";
        };
      };
    };
  };
}

