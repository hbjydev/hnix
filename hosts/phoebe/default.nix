# Phoebe - My home server
{ ... }:
{
  imports = [
    ../../nixos/profiles/server.nix  # Server config

    # Hardware config for the server
    ./hardware-configuration.nix

    # Users
    (import ../../nixos/users/hayden.nix { desktop = false; })

    # Services
    ../../nixos/roles/alloy
    ../../nixos/roles/arr
    ../../nixos/roles/cgit
    ../../nixos/roles/home-assistant
    ../../nixos/roles/jellyfin
    ../../nixos/roles/matrix
    ../../nixos/roles/paperless
    ../../nixos/roles/unifi
  ];

  sops.secrets.matrix_sliding_sync_env.sopsFile = ./secrets/matrix.yaml;
}
