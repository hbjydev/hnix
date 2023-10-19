{ pkgs, inputs, work, ... }:

with pkgs; [
  _1password
  awscli2
  bun
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
  nmap
  podman-compose
  pyenv
  ripgrep
  tilt
  viddy

  inputs.fh.packages.${pkgs.system}.default # flakehub cli
] ++ pkgs.lib.lists.optionals work [
  bitwarden-cli
]
