{ ... }:
{
  services.nginx = {
    enable = true;

    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts = let
      base = locations: {
        inherit locations;
        forceSSL = true;
        enableACME = true;
        http2 = true;
      };
      proxy = port: base {
        "/" = {
          proxyPass = "http://127.0.0.1:" + toString(port) + "/";
          proxyWebsockets = true;
          extraConfig = ''
            proxy_pass_header Authorization;
          '';
        };
      };
    in {
      "home.hbjy.io" = proxy 8123;
      "plex.hbjy.io" = proxy 32400;
      "calibre.hbjy.io" = proxy 8083;
      "media.hbjy.io" = proxy 5055;

      "sabnzbd.hbjy.io" = proxy 8080;
      "prowlarr.hbjy.io" = proxy 9696;
      "radarr.hbjy.io" = proxy 7878;
      "sonarr.hbjy.io" = proxy 8989;
      "lidarr.hbjy.io" = proxy 8686;
      "readarr.hbjy.io" = proxy 8787;
    };
  };

  security.acme = {
    acceptTerms = true;
    email = "admin@kuraudo.io";
  };
}
