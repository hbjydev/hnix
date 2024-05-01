{ pkgs, ... }:
let
  inherit (pkgs) steamcmd steam-tui;
in
{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  environment.systemPackages = [
    steamcmd steam-tui
  ];
}
