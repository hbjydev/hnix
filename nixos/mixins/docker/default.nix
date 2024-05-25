{ ... }:
{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };

  environment.etc."alloy/docker.alloy" = {
    source = ./config.alloy;
    mode = "0440";
    gid = 473;
    user = "root";
  };
}
