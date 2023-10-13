{ trunk, ... }:
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
  services.sabnzbd = mkMediaService {
    package = trunk.sabnzbd;
  };

  # Automation
  services.prowlarr.enable = true;
  services.radarr = mkMediaService {};
  services.sonarr = mkMediaService {};
  services.lidarr = mkMediaService {};
  services.readarr = mkMediaService {};

  services.plex = mkMediaService { dataDir = "/storage/plex"; };

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

  virtualisation.oci-containers.containers = {
    overseerr = {
      autoStart = true;
      image = "sctx/overseerr";
      environment = {
        LOG_LEVEL = "info";
        TZ = "Europe/London";
        PORT = "5055";
      };
      ports = [ "5055:5055" ];
      volumes = [
        "/storage/overseerr:/app/config"
      ];
    };

    homarr = {
      autoStart = true;
      image = "ghcr.io/ajnart/homarr";
      ports = [ "7575:7575" ];
      volumes = [
        "/storage/homarr/configs:/app/data/configs"
        "/storage/homarr/icons:/app/public/icons"
      ];
    };
  };
}
