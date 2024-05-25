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
    ../../nixos/roles/arr.nix
    ../../nixos/roles/cgit.nix
    ../../nixos/roles/home-assistant.nix
    ../../nixos/roles/jellyfin.nix
    ../../nixos/roles/matrix.nix
    ../../nixos/roles/paperless.nix
    ../../nixos/roles/unifi.nix
  ];

  sops.secrets.matrix_sliding_sync_env.sopsFile = ./secrets/matrix.yaml;
}
