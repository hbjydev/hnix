{ config, lib, ... }:
let
  alloyEnabled = builtins.hasAttr "alloy" config.services && config.services.alloy.enable;
in
{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  systemd.services = lib.mkIf alloyEnabled {
    alloy.serviceConfig.SupplementaryGroups = [ "docker" ];
  };

  environment.etc = lib.mkIf alloyEnabled {
    "alloy/docker.alloy".source = ./config.alloy;
  };
}
