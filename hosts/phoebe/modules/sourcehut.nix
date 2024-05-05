{ config, ... }:
{
  imports = [ ./nginx.nix ];

  sops.secrets.srht_netkey = {
    sopsFile = ../secrets/sourcehut.yaml;
    owner = "root";
  };
  sops.secrets.srht_srvkey = {
    sopsFile = ../secrets/sourcehut.yaml;
    owner = "root";
  };
  sops.secrets.srht_whprivkey = {
    sopsFile = ../secrets/sourcehut.yaml;
    owner = "root";
  };
  sops.secrets.srht_ssl_cert = {
    sopsFile = ../secrets/sourcehut.yaml;
    owner = "root";
  };
  sops.secrets.srht_ssl_key = {
    sopsFile = ../secrets/sourcehut.yaml;
    owner = "root";
  };

  services.sourcehut = {
    enable = true;
    git.enable = true;
    man.enable = true;
    meta.enable = true;
    nginx.enable = true;
    postgresql.enable = true;
    redis.enable = true;
    settings = {
      "sr.ht" = {
        environment = "production";
        global-domain = "kuraudo.work";
        origin = "https://kuraudo.work";
        network-key = config.sops.secrets.srht_netkey.path;
        service-key = config.sops.secrets.srht_srvkey.path;
      };

      "git.sr.ht" = {
        oauth-client-id = "CHANGEME";
        oauth-client-secret = "CHANGEME";
      };

      webhooks.private-key = config.sops.secrets.srht_whprivkey.path;
    };
  };

  services.nginx.virtualHosts."git.kuraudo.work" = {
    sslCertificate = config.sops.secrets.srht_ssl_cert.path;
    sslCertificateKey = config.sops.secrets.srht_ssl_key.path;
  };

  services.nginx.virtualHosts."meta.kuraudo.work" = {
    sslCertificate = config.sops.secrets.srht_ssl_cert.path;
    sslCertificateKey = config.sops.secrets.srht_ssl_key.path;
  };

  services.nginx.virtualHosts."man.kuraudo.work" = {
    sslCertificate = config.sops.secrets.srht_ssl_cert.path;
    sslCertificateKey = config.sops.secrets.srht_ssl_key.path;
  };
}
