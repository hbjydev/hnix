{ ... }:
{
  virtualisation = {
    docker.enable = true;
    oci-containers.backend = "docker";
  };
}
