{ inputs, work }:

{ ... }:
{
  _module.args = { inherit inputs work; };

  imports = [
    # third party
    inputs.ghostty-hm.homeModules.default

    # mine
    ./modules/dev.nix
    ./modules/gh
    ./modules/git.nix
    ./modules/nix.nix
    ./modules/pyenv.nix
    ./modules/sops.nix
    ./modules/ssh.nix
    ./modules/zsh.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    PATH = "$PATH:$GOPATH/bin";
  };

  home.file.".background-img".source = ../img/lain.jpg;

  home.stateVersion = "23.05";
}
