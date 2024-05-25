# Configures a Conduit homeserver for use on Matrix.
{ config, ... }:
let
  domain = "hayden.moe";
in
{
  imports = [
    ../mixins/nginx.nix
  ];

  sops.secrets.matrix_sliding_sync_env = {
    owner = "root";
    restartUnits = [ "matrix-sliding-sync.service" ];
  };

  services.nginx.virtualHosts."matrix.${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/_matrix" = {
      proxyPass = "http://localhost:6167";
    };
  };

  services.nginx.virtualHosts."matrixsync.${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:8009";
    };
  };

  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        server_name = domain;
        database_backend = "rocksdb";
        trusted_servers = [ "matrix.org" "nixos.org" "libera.chat" ];
      };
    };
  };

  services.matrix-sliding-sync = {
    enable = true;
    environmentFile = config.sops.secrets.matrix_sliding_sync_env.path;
    settings = {
      SYNCV3_SERVER = "https://matrix.${domain}";
      SYNCV3_DB = "postgresql://slidingsync@127.0.0.1/slidingsync?sslmode=disable";
      SYNCV3_BINDADDR = "0.0.0.0:8009";
    };
  };

  services.postgresql = {
    enable = true;
    authentication = "host all all 127.0.0.1/32 trust";
    ensureDatabases = [ "slidingsync" ];
    ensureUsers = [{
      name = "slidingsync";
      ensureDBOwnership = true;
    }];
  };
}
