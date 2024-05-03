# Configures a Conduit homeserver for use on Matrix.
{ ... }:
{
  services.nginx = {
    enable = true;
    clientMaxBodySize = "10m";
    virtualHosts = {
      "matrix.hayden.moe" = {
        locations."/_matrix" = {
          proxyPass = "http://localhost:6167";
        };
      };
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
    settings = {
      SYNCV3_SERVER = "https://hayden.moe";
      SYNCV3_DB = "postgresql://slidingsync@127.0.0.1/slidingsync";
      SYNCV3_BINDADDR = "0.0.0.0:8009";
    };
  };

  services.postgresql = {
    enable = true;
    authentication = "host all all 127.0.0.1/32 trust";
    ensureDatabases = [ "slidingsync" ];
    ensureUsers = [{
      name = "slidingsync";
      ensurePermissions."DATABASE slidingsync" = "ALL PRIVILEGES";
    }];
  };
}
