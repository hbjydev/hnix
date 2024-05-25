{ config, ... }:
let
  domain = "hayden.moe";
in
{
  imports = [
    ../../mixins/docker
    ../../mixins/nas
    ../../mixins/nginx
  ];

  services.paperless = {
    enable         = true;
    mediaDir       = "/storage/paperless/media";
    consumptionDir = "/storage/paperless/imports";
    dataDir        = "/storage/paperless/data";
    port           = 58080;

    settings = {
      PAPERLESS_TIKA_ENABLED = "1";
      PAPERLESS_TIKA_ENDPOINT = "http://127.0.0.1:9998";
      PAPERLESS_TIKA_GOTENBURG_ENDPOINT = "http://127.0.0.1:3000";
    };
  };

  services.nginx.virtualHosts."docs.${domain}" = {
    enableACME = true;
    forceSSL = true;
    kTLS = true;
    locations."/" = {
      proxyPass = "http://127.0.0.1:${toString config.services.paperless.port}";
      proxyWebsockets = true;
    };
  };

  virtualisation.oci-containers.containers = {
    tika = {
      autoStart = true;
      image = "apache/tika:2.9.1.0-full";
      ports = [ "9998:9998" ];
    };
    gotenburg = {
      autoStart = true;
      image = "gotenberg/gotenberg:8.0.3";
      ports = [ "3000:3000" ];
    };
  };
}
