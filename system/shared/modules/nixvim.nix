{ pkgs, lib, ... }:

let
  vim-just = pkgs.vimUtils.buildVimPlugin {
    name = "vim-just";
    src = pkgs.fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "927b41825b9cd07a40fc15b4c68635c4b36fa923";
      sha256 = "sha256-BmxYWUVBzTowH68eWNrQKV1fNN9d1hRuCnXqbEagRoY=";
    };
  };

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

    extraPlugins = with pkgs.vimPlugins; [
      vim-just
      friendly-snippets
    ];

    extraConfigLuaPre = ''
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end
    '';

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
      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      # misc
      wrap = false;
      termguicolors = true;
      scrolloff = 8;
      colorcolumn = "80";
      cursorline = true;
      completeopt = "menu,menuone,noselect";
    };

    globals.mapleader = " ";

    plugins = {
      alpha = {
        enable = true;
        iconsEnabled = true;

        layout = let
          centeredText = {
            position = "center";
            hl = "@comment";
          };

          mkPadding = size: { type = "padding"; val = size; };
          mkText = text: { type = "text"; val = text; opts = centeredText; };

          mkGroup = val: { inherit val; type = "group"; };
          mkGroupItem = desc: shortcut: {
            inherit shortcut desc;
            command = "";
          };
        in [
          (mkPadding 2)
          (mkText ''
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⣶⡄⠱⣦⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⡿⠛⠉⡙⣿⣿⡄⢹⣧⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⡿⢋⣠⠾⠋⠉⢹⣿⣷⢸⣿⡆⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣼⣿⠏⣠⠞⠁⠀⠀⠀⢸⣿⣿⢸⣿⡇⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⠟⢡⡾⠋⠀⠀⠀⠀⠀⢸⣿⡇⢸⣿⠃⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣴⡿⠁⣴⡟⠁⠀⠀⠀⠀⠀⠀⣿⡿⠀⣾⡟⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⠏⢠⣾⠏⠀⠀⠀⠀⠀⠀⠀⣼⠟⢁⣼⣿⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⣴⣄⠁⠰⡿⠃⠀⠀⠀⠀⠀⠀⢠⡾⠁⣴⣿⣿⡟⠀⠀⠀
⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⣿⠆⠀⠀⠀⠀⠀⠀⠀⢀⡿⢀⣾⣿⣿⣿⡇⠀⠀⠀
⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⡼⠁⣼⡿⢃⣿⣿⠇⠀⠀⠀
⠀⠀⠀⢠⣾⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢷⣼⠟⠁⣸⣿⠏⠀⠀⠀⠀
⠀⠀⣰⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠻⠃⠀⠀⠀⠀⠀
⠀⣾⣿⣿⣿⡟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠛⠛⠛⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
          '')

          (mkPadding 2)

          (mkText ''
          "Gordon doesn't need to hear all this,
           he's a highly trained professional"
                - Dr. Coomer PhD, 2000
          '')
        ];
      };

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
          yamlls.enable = true;
        };
      };
      fidget.enable = true;
      rust-tools.enable = true;

      treesitter = {
        enable = true;
        indent = true;
        folding = true;
      };

      treesitter-context.enable = true;
      #rainbow-delimiters.enable = true;
      nix.enable = true;

      telescope = {
        enable = true;
        keymaps = {
          "<leader>pf" = "find_files";
          "<leader>ps" = "live_grep";
          "<leader>pg" = "git_files";
          "<C-p>" = "git_files";
          "<leader><space>" = "buffers";
          "<leader>ds" = "lsp_document_symbols";
          "<leader>rr" = "lsp_references";
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
        preselect = "None";

        mapping = {
          "<C-p>" = "cmp.mapping.select_prev_item()";
          "<C-n>" = "cmp.mapping.select_next_item()";

          "<C-d>" = "cmp.mapping.scroll_docs(-4)";
          "<C-f>" = "cmp.mapping.scroll_docs(4)";

          "<C-Space>" = "cmp.mapping.complete({})";
          "<C-e>" = "cmp.mapping.close()";

          "<C-y>" = "cmp.mapping.confirm()";

          "<Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_next_item()
                elseif require("luasnip").expand_or_locally_jumpable() then
                  require("luasnip").expand_or_jump()
                elseif has_words_before() then
                  cmp.complete()
                else
                  fallback()
                end
              end
            '';
          };

          "<S-Tab>" = {
            modes = [ "i" "s" ];
            action = ''
              function(fallback)
                if cmp.visible() then
                  cmp.select_prev_item()
                elseif require("luasnip").jumpable(-1) then
                  require("luasnip").jump(-1)
                else
                  fallback()
                end
              end
            '';
          };
        };

        formatting = {
          fields = [ "kind" "abbr" "menu" ];
          format = ''
            function(_, vim_item)
              local icons = {
                Text = "  ",
                Method = "  ",
                Function = "  ",
                Constructor = "  ",
                Field = "  ",
                Variable = "  ",
                Class = "  ",
                Interface = "  ",
                Module = "  ",
                Property = "  ",
                Unit = "  ",
                Value = "  ",
                Enum = "  ",
                Keyword = "  ",
                Snippet = "  ",
                Color = "  ",
                File = "  ",
                Reference = "  ",
                Folder = "  ",
                EnumMember = "  ",
                Constant = "  ",
                Struct = "  ",
                Event = "  ",
                Operator = "  ",
                TypeParameter = "  ",
              }

              vim_item.menu = vim_item.kind
              vim_item.kind = icons[vim_item.kind]
              return vim_item
            end
          '';
        };

        snippet = {
          expand = "luasnip";
        };

        sources = [
          { name = "nvim_lsp"; groupIndex = 1; }
          { name = "nvim_lsp_document_symbol"; groupIndex = 1; }
          { name = "nvim_lsp_signature_help"; groupIndex = 1; }
          { name = "luasnip"; groupIndex = 2; }
          { name = "path"; groupIndex = 3; }
        ];
      };

      cmp-nvim-lsp.enable = true;
      cmp-nvim-lsp-document-symbol.enable = true;
      cmp-nvim-lsp-signature-help.enable = true;
      cmp-nvim-lua.enable = true;
      cmp_luasnip.enable = true;

      luasnip = {
        enable = true;
        fromVscode = [{}];
      };

      neo-tree = {
        enable = true;
        window = {
          position = "float";
        };
      };

      gitsigns.enable = true;
      diffview.enable = true;

      indent-blankline = {
        enable = true;
        indent = {
          highlight = "FoldColumn";
          smartIndentCap = true;
        };
        scope = {
          highlight = "NvimTreeIndentMarker";
        };
      };

      comment-nvim.enable = true;
    };

    extraConfigLua = ''
      ${builtins.readFile ../../../config/nvim/lua/hbjy/statusline.lua}
    '';
  };
}
