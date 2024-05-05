{ config, lib, ... }:
let
  secretRef = name: config.sops.secrets."srht_${name}".path;
  sourcehutSecret = name: {
    sopsFile = ../secrets/sourcehut.yaml;
    owner = "nobody";
    group = "srht";
    mode = "0440";
  };
  cfOriginCert = {
    forceSSL = lib.mkForce false;
    sslCertificate = secretRef "ssl_cert";
    sslCertificateKey = secretRef "ssl_key";
  };
in
{
  imports = [ ./nginx.nix ];

  services.sourcehut = {
    enable = true;
    postgresql.enable = true;
    redis.enable = true;
    nginx.enable = true;
    listenAddress = "127.0.0.1";

    git = { enable = true; group = "srht"; };
    meta = { enable = true; group = "srht"; };

    settings = {
      "sr.ht" = {
        environment = "production";
        global-domain = "kuraudo.work";
        origin = "https://kuraudo.work";
        network-key = secretRef "netkey";
        service-key = secretRef "srvkey";
      };

      mail = {
        smtp-host = "localhost";
        smtp-encryption = "insecure";
        smtp-auth = "none";
        smtp-port = 25;
        smtp-from = "srht@kuraudo.work";

        error-to = "srht@kuraudo.io";
        error-from = "srht-err@kuraudo.work";

        pgp-key-id = "32c7502feededd313f72d0f5826d3b9438e32fc1";
        pgp-privkey = secretRef "pgp_privkey";
        pgp-pubkey = secretRef "pgp_pubkey";
      };

      "git.sr.ht" = {
        oauth-client-id = secretRef "git_o2_ci";
        oauth-client-secret = secretRef "git_o2_cs";
      };

      "man.sr.ht" = {
        oauth-client-id = secretRef "man_o2_ci";
        oauth-client-secret = secretRef "man_o2_cs";
      };

      webhooks.private-key = secretRef "whprivkey";
    };
  };

  systemd.services.gitsrht.serviceConfig.BindPaths = [ "/run:/run" ];
  systemd.services.gitsrht-api.serviceConfig.BindPaths = [ "/run:/run" ];

  systemd.services.metasrht.serviceConfig.BindPaths = [ "/run:/run" ];
  systemd.services.metasrht-api.serviceConfig.BindPaths = [ "/run:/run" ];

  systemd.services.mansrht.serviceConfig.BindPaths = [ "/run:/run" ];
  systemd.services.mansrht-api.serviceConfig.BindPaths = [ "/run:/run" ];

  services.postfix = {
    enable = true;
    enableSmtp = lib.mkForce true;
    config = {
      inet_interfaces = "loopback-only";
    };
  };

  systemd.tmpfiles.rules = [
    # /var/log is owned by root
    "f /var/log/gitsrht-update-hook 0644 ${config.services.sourcehut.git.user} ${config.services.sourcehut.git.group} -"
    "f /var/log/gitsrht-shell 0644 ${config.services.sourcehut.git.user} ${config.services.sourcehut.git.group} -"
  ];

  services.nginx.virtualHosts."git.kuraudo.work" = cfOriginCert;
  services.nginx.virtualHosts."meta.kuraudo.work" = cfOriginCert;
  services.nginx.virtualHosts."man.kuraudo.work" = cfOriginCert;

  sops.secrets.srht_netkey = sourcehutSecret "network-key";
  sops.secrets.srht_srvkey = sourcehutSecret "service-key";
  sops.secrets.srht_whprivkey = sourcehutSecret "webhooks-private-key";

  sops.secrets.srht_pgp_pubkey = sourcehutSecret "pgp-pub-key";
  sops.secrets.srht_pgp_privkey = sourcehutSecret "pgp-priv-key";

  sops.secrets.srht_ssl_cert = sourcehutSecret "ssl-cert" // { owner = "nginx"; };
  sops.secrets.srht_ssl_key = sourcehutSecret "ssl-cert-key" // { owner = "nginx"; };

  sops.secrets.srht_git_o2_ci = sourcehutSecret "git-oauth-client-id";
  sops.secrets.srht_git_o2_cs = sourcehutSecret "git-oauth-client-secret";
  sops.secrets.srht_man_o2_ci = sourcehutSecret "man-oauth-client-id";
  sops.secrets.srht_man_o2_cs = sourcehutSecret "man-oauth-client-secret";
}
