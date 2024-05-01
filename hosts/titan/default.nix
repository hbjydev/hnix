# Titan - My development box & Linux streaming PC
{ config, lib, pkgs, ... }:
{
  imports = [
    ../.  # Base config
    ../home.nix  # Home network config

    # Hardware config for the server
    ./hardware-configuration.nix

    # Users
    ../users/hayden.nix

    # Services
    ./modules/desktop.nix
  ];

  boot.loader = {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
  };

  environment.systemPackages = [
    pkgs.twingate
    pkgs.obs-studio
    pkgs.obs-studio-plugins.wlrobs
  ];

  services.twingate.enable = true;

  networking.firewall.enable = false;
  networking.networkmanager.enable = true;
}
