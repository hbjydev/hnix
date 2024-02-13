{ config, ... }:
{
  imports = [
    ../../../lib/nixosModules/grafana-agent-flow.nix
  ];

  sops.secrets = {
    "gc_token" = {
      sopsFile = ../secrets/grafana-cloud.yaml;
      owner = "grafana-agent-flow";
      restartUnits = [ "grafana-agent-flow.service" ];
    };
    "hass_token" = {
      sopsFile = ../secrets/grafana-cloud.yaml;
      owner = "grafana-agent-flow";
      restartUnits = [ "grafana-agent-flow.service" ];
    };
  };

  services.grafana-agent-flow = {
    enable = true;
    enableJournaldLogging = true;

    grafanaCloud = {
      enable = true;
      stack = "kuraudo";
      tokenFile = config.sops.secrets.gc_token.path;
    };

    staticScrapes = {
      hass = {
        targets = [ "localhost:8123" ];
        bearerTokenFile = config.sops.secrets.hass_token.path;
        metricsPath = "/api/prometheus";
      };

      jellyfin = {
        targets = [ "localhost:8096" ];
      };

      cloudflared = {
        targets = [ "localhost:8927" ];
      };
    };
  };
}
