{ ... }:
{
  imports = [
    ./gh.nix
    ./git.nix
    ./nix.nix
    ./packages.nix
    ./pyenv.nix
    ./sops.nix
    ./ssh.nix
    ./zsh.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    PATH = "$PATH:$GOPATH/bin";
  };

  home.file.".background-img".source = ../../../img/lain.jpg;

  home.stateVersion = "23.05";
}
