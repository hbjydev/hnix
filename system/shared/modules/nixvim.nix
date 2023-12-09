{ lib, ... }:

let
  mkKeymap = mode: key: action: {
    key = key;
    action = action;
    mode =
      if builtins.isList mode
        then mode
        else [ mode ];
  };

  mkNormap = key: action: (mkKeymap "n" key action);
  mkInsmap = key: action: (mkKeymap "i" key action);
in

{
  programs.nixvim = {
    enable = true;
    colorschemes.oxocarbon.enable = true;

    keymaps = [
      (mkNormap "Y" "yg$")
      (mkNormap "J" "mzJ`z")
      (mkNormap "<C-d>" "<C-d>zz")
      (mkNormap "<C-u>" "<C-u>zz")
      (mkNormap "n" "nzzzv")
      (mkNormap "N" "Nzzzv")

      (mkNormap "<leader>b]" "<cmd>bn<cr>")
      (mkNormap "<leader>b[" "<cmd>bp<cr>")
      (mkNormap "<leader>bd" "<cmd>bd<cr>")

      (mkKeymap "x" "<leader>p" "\"_dP")

      (mkKeymap [ "n" "v" ] "<leader>y" "\"+y")
      (mkNormap "<leader>Y" "\"+Y")

      (mkKeymap [ "n" "v" ] "<leader>d" "\"_d")

      (mkInsmap "<C-c>" "<Esc>")

      (mkNormap "Q" "<Nop>")

      (mkNormap "<C-k>" "<cmd>cnext<CR>zz")
      (mkNormap "<C-j>" "<cmd>cprev<CR>zz")
      (mkNormap "<leader>j" "<cmd>lnext<CR>zz")
      (mkNormap "<leader>k" "<cmd>lprev<CR>zz")

      (mkNormap "<leader>pv" ":Neotree toggle<CR>")
    ];

    options = {
      # numbering
      number = true;
      relativenumber = true;

      # indentation
      tabstop = 2;
      softtabstop = 2;
      shiftwidth = 2;
      expandtab = true;
      smartindent = true;

      # swap, backup, undo
      swapfile = false;
      backup = false;
      undofile = false;

      # search
      incsearch = true;
      hlsearch = true;

      # code folding
      foldcolumn = "1";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      # misc
      wrap = true;
      termguicolors = true;
      scrolloff = 8;
      colorcolumn = "80";
      cursorline = true;
    };

    globals.mapleader = " ";

    plugins = {
      lsp = {
        enable = true;
        keymaps = {
          silent = true;

          diagnostic = {
            "<leader>do" = "open_float";
            "[d" = "goto_prev";
            "]d" = "goto_next";
          };

          lspBuf = {
            "gd" = "definition";
            #"gD" = "references";
            "gt" = "type_definition";
            "K" = "hover";
            "<leader>ca" = "code_action";
            "<leader>rn" = "rename";
            "<leader>F" = "format";
          };
        };

        servers = {
          bashls.enable = true;
          cssls.enable = true;
          dockerls.enable = true;
          gopls.enable = true;
          html.enable = true;
          jsonls.enable = true;
          lua-ls.enable = true;
          nixd.enable = true;

          pylsp = {
            enable = true;
            settings.plugins = {
              flake8.enabled = false;
              pycodestyle.enabled = false;
              pylsp_mypy.report_progress = true;

              isort.enabled = true;
              black.enabled = true;
              ruff.enabled = false;
            };
          };

          sourcekit.enable = true;
          terraformls.enable = true;
          tsserver.enable = true;
        };
      };
      fidget.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        folding = true;
      };
      treesitter-context.enable = true;
      rainbow-delimiters.enable = true;
      nix.enable = true;

      telescope = {
        enable = true;
        keymaps = {
          "<leader>pf" = "find_files";
          "<leader>ps" = "live_grep";
          "<leader>pg" = "git_files";
          "<C-p>" = "git_files";
          "<leader><space>" = "buffers";
        };

        defaults = {
          prompt_prefix = "   ";
          selection_caret = "  ";
          entry_prefix = "  ";
          sorting_strategy = "ascending";

          layout_strategy = "flex";
          layout_config = {
            horizontal = {
              prompt_position = "top";
              preview_width = 0.55;
            };
            vertical.mirror = false;
            width = 0.87;
            height = 0.8;
            preview_cutoff = 120;
          };

          dynamic_preview_title = true;

          set_env = {
            COLORTERM = "truecolor";
          };

          file_ignore_patterns = [
            "node_modules"
            ".direnv"
            "venv"
            "vendor"
          ];
        };
      };

      nvim-cmp = {
        enable = true;
      };

      neo-tree = {
        enable = true;
      };

      comment-nvim.enable = true;
    };

    extraConfigLua = ''
      ${builtins.readFile ../../../config/nvim/lua/hbjy/statusline.lua}
    '';
  };
}
