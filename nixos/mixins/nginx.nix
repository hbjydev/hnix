{ ... }:
{
  services.nginx = {
    enable = true;

    clientMaxBodySize = "10m";

    recommendedBrotliSettings = true;
    recommendedGzipSettings = true;
    recommendedOptimisation = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;
    recommendedZstdSettings = true;

    # Log to journal instead of /var/log
    commonHttpConfig = "access_log syslog:server=unix:/dev/log";
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "acme@kuraudo.io";
  };
}
