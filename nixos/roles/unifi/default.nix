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

  networking.firewall.allowedTCPPorts = [ 8443 51893 ];
  networking.firewall.allowedUDPPorts = [ 514 ];

  # Configure a syslog server for devices to log to
  environment.etc = lib.mkIf alloyEnabled {
    "alloy/unifi.alloy" = {
      source = ./config.alloy;
      mode = "0440";
      user = config.services.alloy.user;
    };
  };

  services.syslog-ng = lib.mkIf alloyEnabled {
    enable = true;
    extraConfig = ''
      source udp { syslog(ip(0.0.0.0) port(514) transport("udp")); };
      destination syslog_in { file("/var/log/syslog-in"); };
      log { source(udp); destination(syslog_in); };
    '';
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
