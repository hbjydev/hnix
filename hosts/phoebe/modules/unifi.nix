{ ... }:
{
  virtualisation.oci-containers.containers = {
    unifi = {
      autoStart = true;
      image = "jacobalberty/unifi:v8.1.113";
      user = "root";
      ports = [
        "8080:8080"
        "8443:8443"
        "3478:3478/udp"
        "8843:8843"
        "8880:8880"
      ];
      environment = {
        "TZ" = "Europe/London";
      };
      volumes = [
        "/local/unifi:/unifi"
      ];
    };
  };
}
