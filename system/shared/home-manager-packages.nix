{ pkgs, inputs, work, ... }:

with pkgs; [
  _1password
  awscli2
  bun
  cachix
  ctlptl
  doppler
  fd
  glab
  httpie
  jq
  just
  k9s
  kind
  kubectl
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
