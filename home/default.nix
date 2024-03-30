{ inputs, work, wsl ? false }:

{ pkgs, ... }:
let
  isDarwin = pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin";
in
{
  _module.args = { inherit inputs work isDarwin wsl; };

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
