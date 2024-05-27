{ config, lib, pkgs, ... }:
let
  alloyEnabled = builtins.hasAttr "alloy" config.services && config.services.alloy.enable;
in
{
  services.unifi = {
    enable = true;
    openFirewall = true;
    unifiPackage = pkgs.unifi8;
    mongodbPackage = pkgs.mongodb;
  };

  networking.firewall.allowedTCPPorts = [ 8443 ];

  # Configure a syslog server for devices to log to
  environment.etc = lib.mkIf alloyEnabled {
    "alloy/unifi.alloy" = {
      source = ./config.alloy;
      mode = "0440";
      user = config.services.alloy.user;
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
        cp /var/lib/unifi/data/backup/autobackup/*.unf /storage/unifi/backup/
      '';
    };
  };
}
