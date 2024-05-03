{ config, pkgs, lib, ... }:
{
  services.cgit.main = {
    enable = true;
    nginx.virtualHost = "cgit.hayden.moe";
    package = pkgs.cgit-pink;
    scanPath = "/var/lib/nginx/html_git";
    settings = {
      css = "/cgit.css";
      logo = "/cgit.png";
      favicon = "/favicon.ico";
      readme = ":README.MD";
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
      root-desc = "Hayden's Git Repositories";
    };
  };
}
