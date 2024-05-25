{ ... }:
let
  inherit (import ../consts.nix) domain;
in
{
  imports = [ ./media.nix ./nas.nix ];

  services.jellyseerr.enable = true;
  services.nginx.virtualHosts."request.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5055";
      proxyWebsockets = true;
    };
  };

  services.jellyfin = {
    enable = true;
    group = "media";
  };

  # Only boot Jellyfin after the NAS has been mounted.
  systemd.services.jellyfin.after = [ "storage.mount" ];

  services.nginx.virtualHosts."media.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8096";
      proxyWebsockets = true;
    };
  };

  # Run invites service for Jellyfin.
  virtualisation.oci-containers.containers = {
    wizarr = {
      autoStart = true;
      image = "ghcr.io/wizarrrr/wizarr:3.5.1";
      ports = [ "5690:5690" ];
      volumes = [
        "/storage/wizarr:/data/database"
      ];
    };
  };

  services.nginx.virtualHosts."invites.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:5690";
      proxyWebsockets = true;
    };
  };
}
