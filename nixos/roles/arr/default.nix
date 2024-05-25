{ ... }:
let
  domain = "hayden.moe";
in
{
  imports = [
    ../../mixins/nginx
    ../../mixins/media
    ../../mixins/nas
  ];

  services.sabnzbd = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."sabnzbd.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8080";
      proxyWebsockets = true;
    };
  };

  services.prowlarr.enable = true;
  services.nginx.virtualHosts."prowlarr.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:9696";
      proxyWebsockets = true;
    };
  };

  services.bazarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."bazarr.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:6767";
      proxyWebsockets = true;
    };
  };

  services.radarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."radarr.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:7878";
      proxyWebsockets = true;
    };
  };

  services.sonarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."sonarr.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8989";
      proxyWebsockets = true;
    };
  };

  services.lidarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."lidarr.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8686";
      proxyWebsockets = true;
    };
  };

  services.readarr = {
    enable = true;
    group = "media";
  };
  services.nginx.virtualHosts."readarr.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:8787";
      proxyWebsockets = true;
    };
  };
}
