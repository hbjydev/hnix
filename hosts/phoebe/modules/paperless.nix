{ ... }:
{
  services.paperless = {
    enable         = true;
    mediaDir       = "/storage/paperless/media";
    consumptionDir = "/storage/paperless/imports";
    dataDir        = "/storage/paperless/data";

    settings = {
      PAPERLESS_TIKA_ENABLED = "1";
      PAPERLESS_TIKA_ENDPOINT = "http://127.0.0.1:9998";
      PAPERLESS_TIKA_GOTENBURG_ENDPOINT = "http://127.0.0.1:3000";
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
