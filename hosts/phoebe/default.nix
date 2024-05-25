# Phoebe - My home server
{ ... }:
{
  imports = [
    ../.  # Base config
    ../server.nix  # Base server config
    ../home.nix  # Home network config

    # Hardware config for the server
    ./hardware-configuration.nix

    # Users
    (import ../users/hayden.nix { desktop = false; })

    # Services
    ./modules/alloy
    ./modules/cgit.nix
    ./modules/cloudflared.nix
    ./modules/home-assistant.nix
    ./modules/matrix.nix
    ./modules/paperless.nix
    ./modules/unifi.nix

    # Media
    ./modules/jellyfin.nix
    ./modules/downloads.nix
  ];

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
}
