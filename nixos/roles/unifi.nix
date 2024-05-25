{ ... }:
{
  imports = [ ../mixins/docker.nix ];

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

  systemd = {
    timers.unifi-backup = {
      wantedBy = [ "timers.target" ];
      partOf = [ "unifi-backup.service" ];
      timerConfig.OnCalendar = "weekly";
    };

    services.unifi-backup = {
      serviceConfig.Type = "oneshot";
      script = ''
        cp /local/unifi/data/backup/autobackup/*.unf /storage/unifi/backup/
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 8080 8443 8843 8880 ];
  networking.firewall.allowedUDPPorts = [ 3478 ];
}
