{ pkgs, inputs, work, ... }:

with pkgs; [
  (pkgs.callPackage ../pkgs/bins {})

  _1password
  awscli2
  bun
  cachix
  ctlptl
  doppler
  fd
  glab
  glow
  gum
  httpie
  jq
  k9s
  kind
  kubectl
  mods
  moreutils
  nmap
  podman-compose
  pyenv
  ripgrep
  sops
  tilt
  viddy

  inputs.hvim.packages.${pkgs.system}.default # my nixos config
] ++ pkgs.lib.lists.optionals work [
  bitwarden-cli
]
