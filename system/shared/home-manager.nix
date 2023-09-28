{ inputs, work }:

{ pkgs, ... }:
let
  isDarwin = pkgs.system == "aarch64-darwin" || pkgs.system == "x86_64-darwin";
  aliases = (import ./aliases.nix) isDarwin;
in
{
  imports = [
    (import ./modules/ssh.nix { inherit work isDarwin; })
    (import ./modules/neovim.nix { inherit inputs; })
    (import ./modules/git.nix { inherit work isDarwin aliases; })
    (import ./modules/zsh.nix { inherit aliases; })
    ./modules/dev.nix
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

  nix.registry = {
    nx.flake = inputs.nixpkgs;
    nxs.flake = inputs.stable;
    nxt.flake = inputs.trunk;
  };
}
