{ attic, ... }:
let
  domain = "cache.hayden.moe";
  url = "https://cache.hayden.moe/";
in
{
  imports = [ attic.nixosModules.atticd ];

  services.atticd = {
    enable = true;

    credentialsFile = "/etc/atticd.env";

    settings = {
      listen = "127.0.0.1:8899";

      allowed-hosts = [domain];
      api-endpoint = url;

      chunking = {
        nar-size-threshold = 64 * 1024;
        min-size = 16 * 1024;
        avg-size = 64 * 1024;
        max-size = 256 * 1024;
      };

      storage = {
        type = "s3";
        region = "eu-west-2";
        bucket = "kuraudoio-nix-bincache";
      };
    };
  };

  services.nginx.virtualHosts.${domain} = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:8899";
    };
  }; 
}
