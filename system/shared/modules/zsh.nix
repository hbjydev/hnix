{ aliases }:
{ ... }:
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

    initExtra = builtins.readFile ../../../config/zsh/extraInit.zsh;
  };
}
