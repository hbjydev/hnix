{ pkgs-nix, config, pkgs, ... }:
{
  imports = [ pkgs-nix.nixosModules.alloy ];

  services.alloy = {
    enable = true;
    package = pkgs-nix.packages.${pkgs.system}.alloy;
    openFirewall = true;
    environmentFiles = [ config.sops.secrets.gc_token.path ];
  };

  sops.secrets.gc_token = {
    owner = "alloy";
    restartUnits = [ "docker-alloy.service" ];
    sopsFile = ../../../secrets/grafana-cloud.yaml;
  };

  environment.etc."alloy/config.alloy" = {
    source = ./config.alloy;
    mode = "0440";
    user = "alloy";
  };
}
