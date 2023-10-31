{ inputs, pkgs, ... }:

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

  rest-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "rest-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "rest-nvim";
      repo = "rest.nvim";
      rev = "8b62563cfb19ffe939a260504944c5975796a682";
      sha256 = "sha256-Vk8NqNQHbE3WggcKUCjIfCKeXDM5IfIcVJxcpowzxoM=";
    };
  };
in

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs; [
      # lsp
      vimPlugins.nvim-lspconfig
      vimPlugins.nvim-treesitter.withAllGrammars
      vimPlugins.rust-tools-nvim
      vimPlugins.fidget-nvim

      # completion
      vimPlugins.nvim-cmp
      vimPlugins.cmp-path
      vimPlugins.cmp-buffer
      vimPlugins.cmp-nvim-lsp
      vimPlugins.cmp-nvim-lsp-signature-help
      vimPlugins.copilot-lua

      # telescope
      vimPlugins.plenary-nvim
      vimPlugins.popup-nvim
      vimPlugins.telescope-nvim
      vimPlugins.nvim-treesitter-context
      vimPlugins.telescope-ui-select-nvim
      vimPlugins.todo-comments-nvim

      # theme
      vimPlugins.oxocarbon-nvim
      vimPlugins.indent-blankline-nvim
      vimPlugins.comment-nvim
      vimPlugins.gitsigns-nvim

      # other
      vimPlugins.nui-nvim
      vimPlugins.gitsigns-nvim
      vimPlugins.neo-tree-nvim
      vimPlugins.nvim-web-devicons
      vimPlugins.editorconfig-nvim
      vimPlugins.neorg
      vimPlugins.neorg-telescope
      vimPlugins.zen-mode-nvim
      rest-nvim
      vim-just

      # my config
      inputs.self.packages.${pkgs.system}.hbjy-nvim
    ];

    extraConfig = ''
      lua << EOF
        require 'hbjy'.init()
      EOF
    '';

    extraPackages = with pkgs; [
      # languages
      jsonnet
      nodejs
      python310Full
      rustc

      # LSPs
      gopls
      jsonnet-language-server
      lua-language-server
      nil
      nodePackages."bash-language-server"
      nodePackages."diagnostic-languageserver"
      nodePackages."dockerfile-language-server-nodejs"
      #nodePackages."pyright"
      nodePackages."typescript"
      nodePackages."typescript-language-server"
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"

      python311Packages."python-lsp-server"

      python311Packages."pyls-flake8"
      python311Packages."flake8"

      python311Packages."python-lsp-black"
      python311Packages."black"

      python311Packages."pyls-isort"
      python311Packages."isort"

      python311Packages."pylsp-mypy"
      python311Packages."mypy"

      python311Packages."pylsp-rope"

      rust-analyzer
      terraform-ls
      sourcekit-lsp

      # formatters
      gofumpt
      golines
      nixpkgs-fmt
      python310Packages.black
      rustfmt

      # tools
      cargo
      gcc
      lazydocker
      yarn
      jq
    ];
  };
}
