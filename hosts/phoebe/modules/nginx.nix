{ ... }:
{
  services.nginx = {
    enable = true;
    clientMaxBodySize = "10m";

    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
  };
}
