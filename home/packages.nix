{ pkgs, inputs, work, ... }:

[
  (pkgs.callPackage ../pkgs/bins {})

  pkgs._1password
  pkgs.awscli2
  pkgs.bun
  pkgs.cachix
  pkgs.ctlptl
  pkgs.doppler
  pkgs.fd
  pkgs.glab
  pkgs.glow
  pkgs.gum
  pkgs.httpie
  pkgs.jq
  pkgs.k9s
  pkgs.kind
  pkgs.kubectl
  pkgs.mods
  pkgs.moreutils
  pkgs.nmap
  pkgs.podman-compose
  pkgs.pyenv
  pkgs.ripgrep
  pkgs.sops
  pkgs.tilt
  pkgs.viddy
  pkgs.weechat

  inputs.hvim.packages.${pkgs.system}.default # my nixos config
  inputs.build-configs.packages.${pkgs.system}.default
] ++ pkgs.lib.lists.optionals work [
  pkgs.bitwarden-cli
]
