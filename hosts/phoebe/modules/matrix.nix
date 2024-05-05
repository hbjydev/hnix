# Configures a Conduit homeserver for use on Matrix.
{ config, ... }:
{
  imports = [ ./nginx.nix ];

  sops.secrets.matrix_sliding_sync_env = {
    sopsFile = ../secrets/matrix.yaml;
    owner = "root";
    restartUnits = [ "matrix-sliding-sync.service" ];
  };

  services.nginx.virtualHosts."matrix.hayden.moe" = {
    locations."/_matrix" = {
      proxyPass = "http://localhost:6167";
    };
  };

  services.matrix-conduit = {
    enable = true;
    settings = {
      global = {
        server_name = "hayden.moe";
        database_backend = "rocksdb";
        trusted_servers = [ "matrix.org" "nixos.org" "libera.chat" ];
      };
    };
  };

  services.matrix-sliding-sync = {
    enable = true;
    environmentFile = config.sops.secrets.matrix_sliding_sync_env.path;
    settings = {
      SYNCV3_SERVER = "https://matrix.hayden.moe";
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
