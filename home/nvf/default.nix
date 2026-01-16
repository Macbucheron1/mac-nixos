{ osConfig ? null, config, ... }:
let
  hasOsConfig = osConfig != null;

  user = config.home.username;

  host =
    if hasOsConfig
    then osConfig.networking.hostName
    else "lenovo-legion"; # change me

  flakePrefix = "(builtins.getFlake (toString ./.)).";

  nixosOptionsExpr = "${flakePrefix}nixosConfigurations.${host}.options";

  # home manager option as a nixos module
  hmOptionsFromNixosExpr =
    "${nixosOptionsExpr}.home-manager.users.type.getSubOptions []";

  # Standalone home manager expr
  hmOptionsFromHomeCfgExpr =
    "${flakePrefix}homeConfigurations.\"${user}@${host}\".options";
in
{
  programs.nvf = {
    enable = true;
    defaultEditor = true;

    settings.vim = {

      keymaps = [
        # Allow to navigate between line if they overflow 
        {
          mode = [ "n" "x" ];
          key = "j";
          action = "v:count == 0 ? 'gj' : 'j'";
          expr = true;
          silent = true;
          desc = "Down";
        }
        {
          mode = [ "n" "x" ];
          key = "<Down>";
          action = "v:count == 0 ? 'gj' : 'j'";
          expr = true;
          silent = true;
          desc = "Down";
        }
        {
          mode = [ "n" "x" ];
          key = "k";
          action = "v:count == 0 ? 'gk' : 'k'";
          expr = true;
          silent = true;
          desc = "Up";
        }
        {
          mode = [ "n" "x" ];
          key = "<Up>";
          action = "v:count == 0 ? 'gk' : 'k'";
          expr = true;
          silent = true;
          desc = "Up";
        }

        # H -> beginning of line
        {
          mode = [ "n" "x" ];
          key = "H";
          action = "^";
          silent = true;
          desc = "Begin of line";
        }

        # L -> end of line
        {
          mode = [ "n" "x" ];
          key = "L";
          action = "$";
          silent = true;
          desc = "End of line";
        }
      ];

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
        markdown = {
          enable = true;
          extensions.render-markdown-nvim.enable = true;
        };
        python = {
          enable = true;
        };
      };

      lsp = {
        enable = true;

        servers.nixd = {
          enable = true;

          settings = {
            # !! This might not work on standalone home manager as host will not exist
            nixd = {
              options =
                if hasOsConfig then {
                  nixos.expr = nixosOptionsExpr;
                  home_manager.expr = hmOptionsFromNixosExpr;
                } else {
                  home_manager.expr = hmOptionsFromHomeCfgExpr;
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
      mini.move.enable = true;
      
      tabline.nvimBufferline = {                  # https://github.com/akinsho/bufferline.nvim
        enable = true;
        setupOpts.options = {
          numbers = "none";
          indicator.style = "none";
          sort_by =  "insert_at_end";
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

