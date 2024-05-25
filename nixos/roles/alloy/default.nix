{ config, ... }:
let
  alloyUid = 473;
  alloyGid = alloyUid;
in
{
  sops.secrets.gc_token = {
    owner = "alloy";
    restartUnits = [ "docker-alloy.service" ];
    sopsFile = ../../../secrets/grafana-cloud.yaml;
  };

  users.extraUsers.alloy = {
    isSystemUser = true;
    home = "/dev/null";
    uid = alloyUid;
    description = "Alloy user";
    createHome = false;
    shell = "/sbin/nologin";
    group = "adm";
  };

  environment.etc."alloy/config.alloy" = {
    source = ./config.alloy;
    mode = "0440";
    gid = alloyGid;
    user = "root";
  };

  virtualisation.oci-containers.containers = {
    alloy = {
      autoStart = true;
      image = "grafana/alloy:v1.0.0";

      user = "root";

      ports = [
        "12345:12345"
      ];

      cmd = [
        "run"
        "--server.http.listen-addr=0.0.0.0:12345"
        "--storage.path=/var/lib/alloy/data"
        "--stability.level=public-preview"
        "/etc/alloy/config.alloy"
      ];

      volumes = [
        # Alloy
        "/var/log:/var/log:ro"
        "/etc/alloy:/etc/alloy:ro"

        # Node Exporter
        "/proc:/host/proc:ro"
        "/sys:/host/sys:ro"
        "/run/udev/data:/host/run/udev/data:ro"
        "/:/rootfs:ro"
      ];

      environmentFiles = [
        config.sops.secrets.gc_token.path
      ];
    };
  };
}
