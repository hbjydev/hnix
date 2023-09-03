{ pkgs, inputs, ... }:

with pkgs; [
  _1password
  awscli2
  doppler
  fd
  glab
  httpie
  jq
  jsonnet
  just
  k9s
  kind
  kubectl
  podman-compose
  pyenv
  ripgrep
  terraform
  tilt
  viddy

  inputs.fh.packages.${pkgs.system}.default # flakehub cli
  inputs.nix-index.packages.${pkgs.system}.default
]
