{ ... }:
{
  services.paperless = {
    enable         = true;
    mediaDir       = "/storage/paperless/media";
    consumptionDir = "/storage/paperless/imports";
    dataDir        = "/storage/paperless/data";
  };
}
