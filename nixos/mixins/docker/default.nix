{ config, lib, ... }:
let
  alloyEnabled = builtins.hasAttr "alloy" config.services && config.services.alloy.enable;
in
{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  users.users.alloy = lib.mkIf alloyEnabled {
    extraGroups = [ "docker" ];
  };

  environment.etc = lib.mkIf alloyEnabled {
    "alloy/docker.alloy" = {
      source = ./config.alloy;
      mode = "0440";
      gid = 473;
      user = "alloy";
    };
  };
}
