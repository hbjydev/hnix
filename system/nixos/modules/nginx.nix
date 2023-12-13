{ ... }:
{
  services.nginx = {
    enable = true;

    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;
    recommendedTlsSettings = true;

    virtualHosts =
      let
        base = locations: {
          inherit locations;
          forceSSL = true;
          enableACME = true;
          http2 = true;
        };
        proxy = port: base {
          "/" = {
            proxyPass = "http://127.0.0.1:" + toString (port) + "/";
            proxyWebsockets = true;
            extraConfig = ''
              proxy_pass_header Authorization;
            '';
          };
        };
      in
      {
        "home.hbjy.io" = proxy 8123;
      };
  };

  security.acme = {
    acceptTerms = true;
    defaults.email = "admin@kuraudo.io";
  };
}
