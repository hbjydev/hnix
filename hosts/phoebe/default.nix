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
    ./modules/alloy
    ./modules/cloudflared.nix
    ./modules/home-assistant.nix
    ./modules/paperless.nix
    ./modules/unifi.nix

    ../../nixos/roles/cgit.nix
    ../../nixos/roles/matrix.nix

    # Media
    ../../nixos/roles/arr.nix
    ../../nixos/roles/jellyfin.nix
  ];

  sops.secrets.matrix_sliding_sync_env = {
    sopsFile = ./secrets/matrix.yaml;
    owner = "root";
    restartUnits = [ "matrix-sliding-sync.service" ];
  };
}
