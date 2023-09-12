{ inputs, work }:

{ pkgs, ... }:

let
  isDarwin = pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin";
  vim-just = pkgs.vimUtils.buildVimPlugin {
    name = "vim-just";
    src = pkgs.fetchFromGitHub {
      owner = "NoahTheDuke";
      repo = "vim-just";
      rev = "927b41825b9cd07a40fc15b4c68635c4b36fa923";
      sha256 = "sha256-BmxYWUVBzTowH68eWNrQKV1fNN9d1hRuCnXqbEagRoY=";
    };
  };

  aliases = (import ./aliases.nix) isDarwin;
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    PATH = "$PATH:$GOPATH/bin";
  };

  home.stateVersion = "23.05";

  programs.bat.enable = true;

  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.ssh = {
    enable = true;
    matchBlocks."*".extraOptions = {
      IdentityAgent = (
        if isDarwin
          then "\"~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock\""
          else "~/.1password/agent.sock"
      );
      ControlMaster = "auto";
      ControlPath = "/tmp/%r@%h:%p";
      ControlPersist = "10m";
      Compression = "yes";
      User = if work then "hyoung" else "";
    };
  };

  programs.git = {
    enable = true;

    aliases = aliases.git;

    ignores =
      if work then [
        ".devenv/"
        ".direnv/"
        ".envrc"
        "__pycache__/"
        ".env"
        ".ropeproject/"
        "flake.nix"
        "flake.lock"
      ] else [
        ".devenv/"
        ".direnv/"
        "__pycache__/"
        ".ropeproject/"
      ];

    userName = "Hayden Young";
    userEmail = (
      if work
      then "hayden.young@zoodigital.com"
      else "22327045+hbjydev@users.noreply.github.com"
    );

    extraConfig = {
      commit = {
        gpgsign = true;
        verbose = false;
      };

      init.defaultBranch = "main";

      rebase = {
        autoStash = true;
      };

      push = {
        autoSetupRemote = true;
        default = "simple";
      };
      pull = {
        rebase = true;
      };

      user.signingKey = (
        if work
        then "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdUGldjr+KGTEcc1XHlpNGRSvBeuPH2fBJz27+28Klw"
        else "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkhuhfzyg7R+O62XSktHufGmmhy6FNDi/NuPPJt7bI+"
      );

      gpg = {
        format = "ssh";
        ssh = {
          program = if isDarwin then "/Applications/1Password.app/Contents/MacOS/op-ssh-sign" else "${pkgs._1password-gui}/share/1password/op-ssh-sign";
        };
      };

      credential = {
        "https://gitlab.zoodigital.com" = {
          helper = "${pkgs.glab}/bin/glab auth git-credential";
        };
      };
    };

    delta = {
      enable = true;
      options = {
        interactive = {
          keep-plus-minus-markers = false;
        };
        decorations = {
          commit-decoration-style = "blue ol";
          commit-style = "raw";
          file-style = "omit";
          hunk-header-decoration-style = "blue box";
          hunk-header-file-style = "red";
          hunk-header-line-number-style = "#067a00";
          hunk-header-style = "file line-number syntax";
        };
      };
    };
  };

  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        logoless = true;
      };
    };
    skin = (builtins.readFile ../../config/k9s/skin.yml);
  };

  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;

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
    ];
  };

  programs.nnn = {
    enable = true;
    plugins = {
      mappings = {
        K = "preview-tui";
      };
      src = (pkgs.fetchFromGitHub {
        owner = "jarun";
        repo = "nnn";
        rev = "18b5371d08e341ddefd2d023e3f7d201cac22b89";
        sha256 = "sha256-L6p7bd5XXOHBZWei21czHC0N0Ne1k2YMuc6QhVdSxcQ=";
      }) + "/plugins";
    };
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    shellAliases = aliases.zsh;

    initExtra = builtins.readFile ../../config/zsh/extraInit.zsh;
  };
}
