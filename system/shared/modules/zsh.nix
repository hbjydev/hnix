{ aliases, ... }:
{
  programs.bat.enable = true;

  programs.eza = {
    enable = true;
    enableAliases = true;
    icons = true;
    git = true;
  };

  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  #programs.starship = {
  #  enable = true;
  #  enableZshIntegration = true;
  #  enableTransience = true;
  #
  #  settings = {
  #    directory.home_symbol = "🏠";
  #  };
  #};

  programs.zsh = {
    enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "z" "aws" ];
      theme = "robbyrussell";
    };

    enableAutosuggestions = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;

    shellAliases = aliases.zsh;

    initExtra = builtins.readFile ../../../config/zsh/extraInit.zsh;
  };
}
