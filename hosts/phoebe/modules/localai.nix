{ ... }:
{
  virtualisation.oci-containers.containers = {
    localai = {
      autoStart = true;
      image = "localai/localai:v2.11.0-aio-cpu";
      ports = [ "8081:8080" ];
      volumes = [
        "/local/models:/build/models:cached"
      ];
    };
  };
}
