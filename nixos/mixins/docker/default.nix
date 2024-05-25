{ config, lib, ... }:
let
  alloyEnabled = config.virtualisation.oci-containers.containers.alloy != null;
in
{
  virtualisation = {
    docker.enable = true;
    oci-containers = {
      backend = "docker";

      containers.alloy.volumes = lib.mkIf alloyEnabled [
        "/var/run/docker.sock:/var/run/docker.sock:ro"
      ];
    };
  };

  environment.etc."alloy/docker.alloy" = lib.mkIf alloyEnabled {
    source = ./config.alloy;
    mode = "0440";
    gid = config.users.extraUsers.alloy.uid;
    user = "root";
  };
}
