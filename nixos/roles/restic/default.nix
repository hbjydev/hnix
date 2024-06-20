{ config, ... }:
let
  secret = name: config.sops.secrets."restic_${name}".path;
in
{
  services.restic.backups = {
    daily = {
      initialize = true;
      environmentFile = secret "env";
      repositoryFile = secret "repo";
      passwordFile = secret "password";
      paths = [
        "/etc"
        "/var/lib/acme"
        "/var/lib/bazarr"
        "/var/lib/hass"
        "/var/lib/jellyfin"
        "/var/lib/jellyseerr"
        "/var/lib/lidarr"
        "/var/lib/matrix-conduit"
        "/var/lib/matrix-sliding-sync"
        "/var/lib/postgresql"
        "/var/lib/prowlarr"
        "/var/lib/radarr"
        "/var/lib/readarr"
        "/var/lib/sabnzbd"
        "/var/lib/sonarr"
        "/var/lib/unifi"
      ];
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 5"
        "--keep-monthly 12"
      ];
    };
  };
}
