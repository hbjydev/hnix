# Titan - My development box & Linux streaming PC
{ pkgs, ... }:
{
  imports = [
    ../../nixos/profiles/desktop.nix  # Desktop config

    # Hardware config for the server
    ./hardware-configuration.nix

    # Users
    ../../users/hayden

    # Services
    ../../nixos/mixins/docker
  ];

  boot.tmp.useTmpfs = true;
  boot.tmp.tmpfsSize = "16G";

  programs._1password.enable = true;

  networking.hostName = "titan";

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
