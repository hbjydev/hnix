{ ... }:

{
  programs.nixvim = {
    enable = true;
    colorschemes.oxocarbon.enable = true;

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

      nvim-cmp = {
        enable = true;
      };
    };
  };
}
