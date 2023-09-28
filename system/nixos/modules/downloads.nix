{ config, lib, pkgs, ... }:
let
  mkMediaService = (attrs:
    {
      enable = true;
      group = "media";
    } // attrs
  );
in
{
  # Shared group to deal with permissions
  users.groups.media = { };

  # Downloads
  services.sabnzbd = mkMediaService {};

  # Automation
  services.prowlarr.enable = true;
  services.radarr = mkMediaService {};
  services.sonarr = mkMediaService {};
  services.lidarr = mkMediaService {};
  services.readarr = mkMediaService {};

  services.calibre-server = mkMediaService {
    port = 8181;
    libraries = [ "/storage/books" ];
    auth = {
      enable = true;
      mode = "basic";
      userDb = "/storage/books/users.db";
    };
  };

  services.calibre-web = mkMediaService {
    listen.ip = "0.0.0.0";
    options.calibreLibrary = "/storage/books";
  };
}
