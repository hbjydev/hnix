{ hostType, pkgs, ... }:
if hostType == "nixos" then {
  home.packages = [
    pkgs.discord
    pkgs.spotify
    pkgs.slack

    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.appindicator
  ];
}
else { }
