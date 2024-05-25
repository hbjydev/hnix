{ ... }:
{
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    icons = true;
    git = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      directory.home_symbol = "🏠";
    };
  };

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "aws" ];
      theme = "robbyrussell";
    };

    autosuggestion.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      s = "doppler run";
      ops = "op run --no-masking";

      cat = "bat";

      vi = "nvim";
      vim = "nvim";

      dc = "docker compose";
      dcu = "docker compose up";
      dcd = "docker compose down";
      dcl = "docker compose logs";
      dclf = "docker compose logs -f";
      dcc = "docker compose cp";
      dci = "docker compose inspect";
      dce = "docker compose exec";
      dcr = "docker compose restart";

      g = "git";

      k = "kubectl";
      kw = "kubectl -o wide";
      ky = "kubectl -o yaml";
      kj = "kubectl -o json";

      tf = "terraform";

      nb = "nix build --json --no-link --print-build-logs";
      lg = "lazygit";

      watch = "viddy";

      wt = "git worktree";
    };

    initExtra = ''
      eval "$(k9s completion zsh)"
    '';
  };
}
