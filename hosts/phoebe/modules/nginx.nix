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

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@kuraudo.io";
  };
}
