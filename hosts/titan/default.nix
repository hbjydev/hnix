# Titan - My development box & Linux streaming PC
{ pkgs, ... }:
{
  imports = [
    ../../nixos/profiles/desktop.nix  # Desktop config

    # Hardware config for the server
    ./hardware-configuration.nix

    # Users
    (import ../../nixos/users/hayden.nix { desktop = true; })

    # Services
    ../../nixos/mixins/docker
  ];

  programs._1password.enable = true;

  services.twingate.enable = true;
  environment.systemPackages = [
    pkgs.twingate
    pkgs.obs-studio
    pkgs.obs-studio-plugins.wlrobs
    pkgs.steamcmd
    pkgs.steam-tui
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  networking.networkmanager.enable = true;
}
