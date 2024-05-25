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
    commonHttpConfig = "access_log syslog:server=unix:/dev/log;";
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ]; # HTTP/3/QUIC

  security.acme = {
    defaults.email = "acme@kuraudo.io";
  };
}
