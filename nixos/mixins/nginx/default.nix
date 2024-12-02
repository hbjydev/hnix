{ config, lib, ... }:
let
  alloyEnabled = builtins.hasAttr "alloy" config.services && config.services.alloy.enable;
  secret = name: config.sops.secrets."restic_${name}".path;
in
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

    statusPage = if alloyEnabled then true else false;
  };

  services.prometheus.exporters.nginx = lib.mkIf alloyEnabled {
    enable = true;
  };

  environment.etc = lib.mkIf alloyEnabled {
    "alloy/nginx.alloy".source = ./config.alloy;
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
  networking.firewall.allowedUDPPorts = [ 443 ]; # HTTP/3/QUIC

  security.acme = {
    defaults.email = "acme@kuraudo.io";
  };

  services.restic.backups.daily.paths = [ "/var/lib/acme" ];
}
