{ pkgs, lib, ... }:
let
  gh-mirror = pkgs.callPackage ../../../pkgs/gh-mirror.nix {};
in
{
  environment.systemPackages = [ gh-mirror ];

  systemd.timers."gh-mirror" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "5m";
      OnUnitActiveSec = "5m";
      Unit = "gh-mirror.service";
    };
  };

  systemd.services."gh-mirror" = {
    script = ''
      set -eu
      ${gh-mirror}/bin/gh-mirror hbjydev
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "hayden";
    };
  };

  services.cgit.main = {
    enable = true;
    nginx.virtualHost = "cgit.hayden.moe";
    package = pkgs.cgit-pink;
    scanPath = "/var/lib/nginx/html_git";
    settings = {
      css = "/cgit.css";
      logo = "/cgit.png";
      favicon = "/favicon.ico";
      readme = ":README.md";
      about-filter = "${pkgs.cgit-pink}/lib/cgit/filters/about-formatting.sh";
      source-filter = "${pkgs.cgit-pink}/lib/cgit/filters/syntax-highlighting.py";
      clone-url = (lib.concatStringsSep " " [
        "https://cgit.hayden.moe/$CGIT_REPO_URL"
      ]);
      enable-log-filecount = 1;
      enable-log-linecount = 1;
      enable-git-config = 1;
      enable-blame = 1;
      enable-commit-graph = 1;
      enable-follow-links = 1;
      enable-index-links = 1;
      enable-remote-branches = 1;
      enable-subject-links = 1;
      enable-tree-linenumbers = 1;
      max-atom-items = 108;
      max-commit-count = 250;
      max-repo-count = 500;
      snapshots = "tar.xz";

      root-title = "cgit.hayden.moe";
      root-desc = "Hayden's local Git mirror for personal projects";
    };
  };
}
