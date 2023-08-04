{ inputs, work }:

{ pkgs, ... }:

let
    isDarwin = pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin";
in
{
  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
  };

  home.stateVersion = "23.05";

  programs.bat.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
  };

  programs.git = {
    enable = true;

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
          program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
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
      vimPlugins.nui-nvim
      vimPlugins.gitsigns-nvim
      vimPlugins.neo-tree-nvim

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
      nodePackages."pyright"
      nodePackages."typescript"
      nodePackages."typescript-language-server"
      nodePackages."vscode-langservers-extracted"
      nodePackages."yaml-language-server"
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

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" ];
      theme = "robbyrussell";
    };

    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      cat = "bat --paging=never";

      ll = if isDarwin then "n" else "n -P K";

      dc = "docker compose";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcl = "docker compose logs";
      dclf = "docker compose logs -f";
      dcc = "docker compose cp";
      dci = "docker compose inspect";
      dce = "docker compose exec";
      dcr = "docker compose restart";

      k = "kubectl";
      kw = "kubectl -o wide";
      ky = "kubectl -o yaml";
      kj = "kubectl -o json";

      tf = "terraform";

      gs = "git status -s";
      ga = "git add";
      gc = "git commit";
      gch = "git checkout";
      gb = "git branch";
      gp = "git pull";
      gpp = "git push";
      gl = "git log --pretty=oneline --abbrev-commit";

      ssh = "TERM=xterm-256color ssh";
    };

    initExtra = ''
      license () {
        curl -L "api.github.com/licenses/$1" | jq -r .body > LICENSE
      }

      n () {
        if [ -n $NNNLVL ] && [ "$NNNLVL" -ge 1 ]; then
          echo "nnn is already running"
          return
        fi

        export NNN_TMPFILE="$HOME/.config/nnn/.lastd"

        nnn -adeHo "$@"

        if [ -f "$NNN_TMPFILE" ]; then
          . "$NNN_TMPFILE"
          rm -f "$NNN_TMPFILE" > /dev/null
        fi
      }
    '';
  };
}