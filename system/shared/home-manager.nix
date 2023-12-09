{ inputs, work, wsl ? false }:

{ pkgs, ... }:
let
  isDarwin = pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin";
  aliases = (import ./aliases.nix) isDarwin;
in
{
  _module.args = { inherit inputs work isDarwin aliases wsl; };

  imports = [
    inputs.nixvim.homeManagerModules.nixvim

    ./modules/dev.nix
    ./modules/ssh.nix
    ./modules/nixvim.nix
    ./modules/git.nix
    ./modules/zsh.nix
    ./modules/nix.nix
  ];

  home.sessionVariables = {
    EDITOR = "nvim";
    LANG = "en_GB.UTF-8";
    LC_ALL = "en_GB.UTF-8";
    LC_CTYPE = "en_GB.UTF-8";
    PATH = "$PATH:$GOPATH/bin";
  };

  home.file.".background-img".source = ../../img/lain.jpg;

  home.stateVersion = "23.05";
}
