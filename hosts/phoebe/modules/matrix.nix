# Configures a Dendrite homeserver for use on Matrix.
{ ... }:
{
  services.nginx = {
    enable = true;
    clientMaxBodySize = "10m";
    commonHttpConfig = ''
      map $http_user_agent $limit_bots {
        default 0;
        ~*(AhrefsBot|PetalBot|bingbot|gptbot|ZoominfoBot|BLEXBot|Bytespider) 1;
        ~*(DecompilationBot|Amazonbot|Barkrowler|SeznamBot|SemrushBot) 1;
        ~*(MJ12bot|IonCrawl|webprosbot|Sogou|paloaltonetworks|CensysInspect) 1;
        ~*(DotBot|ev-crawler|InternetMeasurement|CheckMarkNetwork|panscient) 1;
        ~*(gdnplus|PunkMap|pdrlabs|SurdotlyBot|researchscan|serpstatbot) 1;
        ~*(MegaIndex|DongleEmulatorBot|TinyTestBot) 1;
      }
    '';

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
}
