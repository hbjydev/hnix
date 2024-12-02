{ attic, deploy-rs, hvim, build-configs, pkgs, ... }:
{
  home.packages = [
    (pkgs.callPackage ../../../pkgs/bins {})

    pkgs._1password-cli
    pkgs.act
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
    pkgs.kubernetes-helm
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

    attic.packages.${pkgs.system}.attic
    deploy-rs.packages.${pkgs.system}.default
    hvim.packages.${pkgs.system}.default
    build-configs.packages.${pkgs.system}.default
  ];
}
