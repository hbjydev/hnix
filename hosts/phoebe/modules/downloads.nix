{ ... }:
let
  mkMediaService = (attrs:
    {
      enable = true;
      group = "media";
    } // attrs
  );
in
{
  imports = [
    ../../../nixos/mixins/media.nix
    ../../../nixos/mixins/nas.nix
  ];

  # Downloads
  services.sabnzbd = mkMediaService { };

  # Automation
  services.prowlarr.enable = true;

  services.bazarr = mkMediaService { };
  services.radarr = mkMediaService { };
  services.sonarr = mkMediaService { };
  services.lidarr = mkMediaService { };
  services.readarr = mkMediaService { };

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
