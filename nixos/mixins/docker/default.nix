{ config, lib, ... }:
let
  alloyEnabled = builtins.hasAttr "alloy" config.services && config.services.alloy.enable;
in
{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  users.users = lib.mkIf (alloyEnabled && config.services.alloy.user == "alloy") {
    alloy.extraGroups = [ "docker" ];
  };

  environment.etc = lib.mkIf alloyEnabled {
    "alloy/docker.alloy" = {
      source = ./config.alloy;
      mode = "0440";
      user = config.services.alloy.user;
    };
  };
}
