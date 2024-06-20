{ config, ... }:
{
  sops.secrets.gc_token = {
    owner = config.services.alloy.user;
    restartUnits = [ "alloy.service" ];
    sopsFile = ../../../secrets/grafana-cloud.yaml;
  };

  environment.etc."alloy/config.alloy".source = ./config.alloy;

  services.alloy = {
    enable = true;
    extraFlags = ["--stability.level=public-preview"];
  };

  systemd.services.alloy.serviceConfig.EnvironmentFile = [ config.sops.secrets.gc_token.path ];
}
