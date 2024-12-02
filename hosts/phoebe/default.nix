# Phoebe - My home server
{ ... }:
{
  imports = [
    ../../nixos/profiles/server.nix  # Server config

    # Hardware config for the server
    ./hardware-configuration.nix

    # Users
    ../../users/hayden

    # Services
    ../../nixos/roles/alloy
    ../../nixos/roles/attic
    ../../nixos/roles/arr
    ../../nixos/roles/cgit
    ../../nixos/roles/grocy
    ../../nixos/roles/home-assistant
    ../../nixos/roles/jellyfin
    ../../nixos/roles/lmpserver
    ../../nixos/roles/matrix
    ../../nixos/roles/paperless
    ../../nixos/roles/restic
    ../../nixos/roles/unifi
  ];

  networking.hostName = "phoebe";

  networking.firewall.allowedUDPPorts = [ 2402 2403 2404 2405 2406 9987 ];
  networking.firewall.allowedTCPPorts = [ 10011 30033 ];

  sops.secrets.matrix_sliding_sync_env.sopsFile = ./secrets/matrix.yaml;

  sops.secrets.atticd_env.sopsFile = ./secrets/atticd.yaml;

  sops.secrets.restic_env.sopsFile = ./secrets/restic.yaml;
  sops.secrets.restic_repo.sopsFile = ./secrets/restic.yaml;
  sops.secrets.restic_password.sopsFile = ./secrets/restic.yaml;

  services.nginx.virtualHosts."imgs.hayden.moe" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:3050";
      proxyWebsockets = true;
    };
  };
}
