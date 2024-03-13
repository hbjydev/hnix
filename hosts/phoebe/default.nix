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
    ../users/hayden.nix

    # Services
    ./modules/cloudflared.nix
    ./modules/desktop.nix
    ./modules/downloads.nix
    #./modules/grafana-agent-flow.nix
    ./modules/home-assistant.nix
    ./modules/paperless.nix
  ];

  environment.systemPackages = [pkgs.twingate];

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
}
