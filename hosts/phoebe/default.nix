# Phoebe - My development box & home server
{ config, lib, pkgs, ... }:
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
    ./modules/cloudflared.nix
    ./modules/downloads.nix
    ./modules/home-assistant.nix
    ./modules/matrix.nix
    ./modules/paperless.nix
    ./modules/unifi.nix
  ];

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
}
