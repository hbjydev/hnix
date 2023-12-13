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
  imports = [ ];

  # Shared group (and user for Docker) to deal with permissions
  users.extraUsers.media = {
    isNormalUser = true;
    home = "/dev/null";
    uid = 1234;
    description = "Media user";
    createHome = false;
    shell = "/sbin/nologin";
  };

  users.groups.media = { };

  # Downloads
  services.sabnzbd = mkMediaService {
    package = trunk.sabnzbd;
  };

  # Automation
  services.prowlarr.enable = true;

  services.radarr = mkMediaService { };
  services.sonarr = mkMediaService { };
  services.lidarr = mkMediaService { };
  services.readarr = mkMediaService { };

  services.jellyseerr.enable = true;
  services.jellyfin = mkMediaService { };
  systemd.services.jellyfin.after = [ "storage.mount" ];

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
    wizarr = {
      autoStart = true;
      image = "ghcr.io/wizarrrr/wizarr:3.5.1";
      ports = [ "5690:5690" ];
      volumes = [
        "/storage/wizarr:/data/database"
      ];
    };

    homarr = {
      autoStart = true;
      image = "ghcr.io/ajnart/homarr:0.14.2";
      ports = [ "7575:7575" ];
      volumes = [
        "/storage/homarr/configs:/app/data/configs"
        "/storage/homarr/icons:/app/public/icons"
        "/storage/homarr/data:/data"
      ];
    };
  };
}
