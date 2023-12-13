{ config, lib, ... }:

with lib;

let
  instanceOpts = { name, ... }:
    {
      options = {
        servicePort = mkOption {
          type = types.int;
          default = null;
          description = "The service to configure an instance for";
        };

        onPort = mkOption {
          type = types.int;
          default = null;
          description = "The port to listen on";
        };

        tokenFile = mkOption {
          type = types.str;
          default = null;
          description = "The file to read the token from";
        };
      };
    };

  mkConfig = service: servicePort: port: token:
    {
      systemd.services."docker-exportarr-${service}".after = [ "${service}.service" ];

      services.grafana-agent-flow.staticScrapes."exportarr-${service}" = {
        targets = [ "localhost:${toString port}" ];
      };

      virtualisation.oci-containers.containers."exportarr-${service}" = {
        image = "ghcr.io/onedr0p/exportarr";
        extraOptions = [ "--network=host" ];
        ports = [ "${toString port}:9707" ];
        autoStart = true;
        cmd = [ service ];
        user = "1234";
        volumes = [
          "${token}:${token}:ro"
        ];
        environment = {
          PORT = "9707";
          URL = "http://localhost:${toString servicePort}";
          API_KEY_FILE = tokenPath;
        };
      };
    };

  zipConfigs = configs:
    let
      built = builtins.mapAttrs
        (name: svcConfig:
          (mkConfig name svcConfig.servicePort svcConfig.onPort svcConfig.tokenFile))
        configs;
    in
    (mkMerge built).contents;

  cfg = config.exportarr;
in
{
  options = {
    services.exportarr = {
      enable = mkEnableOption (mdDoc "exportarr");
      services = mkOption {
        type = with types; attrsOf (submodule instanceOpts);
        default = { };
        description = "Configuration for grafana-agent-flow";
      };
    };
  };

  config = mkIf cfg.enable (zipConfigs cfg.services);
}
