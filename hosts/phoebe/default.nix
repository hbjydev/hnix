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
    ./modules/alloy
    ./modules/cloudflared.nix
    ./modules/desktop.nix
    ./modules/downloads.nix
    ./modules/home-assistant.nix
    ./modules/paperless.nix
    ./modules/unifi.nix
  ];

  environment.systemPackages = [
    pkgs.twingate
    pkgs.obs-studio
    pkgs.obs-studio-plugins.wlrobs
  ];

  services.twingate.enable = true;

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
}
