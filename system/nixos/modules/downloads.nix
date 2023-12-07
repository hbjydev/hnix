{ trunk, ... }:
let
  mkMediaService = (attrs:
    {
      enable = true;
      group = "media";
    } // attrs
  );

  mkServarrExporter = { service, url, port }: {
    "exportarr-${service}" = {
      image = "ghcr.io/onedr0p/exportarr:latest";
      ports = [ "${toString port}:9707" ];
      autoStart = true;
      cmd = [ service ];
      user = "1234";
      volumes = [
        "/run/secrets/${service}_key:/run/secrets/${service}_key"
      ];
      environment = {
        PORT = "9707";
        URL = url;
        API_KEY_FILE = "/run/secrets/${service}_key";
      };
    };
  };
in
{
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
  services.radarr = mkMediaService {};
  services.sonarr = mkMediaService {};
  services.lidarr = mkMediaService {};
  services.readarr = mkMediaService {};

  services.jellyseerr.enable = true;
  services.jellyfin = mkMediaService {};
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
  }

    // mkServarrExporter {
      service = "sabnzbd";
      url = "http://192.168.4.3:8080";
      port = 9707;
    }

    // mkServarrExporter {
      service = "lidarr";
      url = "http://192.168.4.3:8686";
      port = 9708;
    }

    // mkServarrExporter {
      service = "prowlarr";
      url = "http://192.168.4.3:9696";
      port = 9709;
    }

    // mkServarrExporter {
      service = "readarr";
      url = "http://192.168.4.3:8787";
      port = 9710;
    }

    // mkServarrExporter {
      service = "radarr";
      url = "http://192.168.4.3:7878";
      port = 9711;
    }

    // mkServarrExporter {
      service = "sonarr";
      url = "http://192.168.4.3:8989";
      port = 9712;
    };
}
