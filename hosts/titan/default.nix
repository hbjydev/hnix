# Titan - My development box & Linux streaming PC
{ pkgs, ... }:
{
  imports = [
    ../.  # Base config
    ../../nixos/profiles/desktop.nix  # Desktop config

    # Hardware config for the server
    ./hardware-configuration.nix

    # Users
    (import ../../nixos/users/hayden.nix { desktop = true; })

    # Services
    ./modules/desktop.nix
    ./modules/steam.nix
  ];

  boot.tmpOnTmpfsSize = "16G";
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
