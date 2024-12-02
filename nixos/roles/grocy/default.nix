{ ... }:
let
  domain = "hayden.moe";
in
{
  imports = [
    ../../mixins/nginx
  ];

  services.grocy.enable = true;
  services.grocy.hostName = "grocy.${domain}";
  services.grocy.settings = {
    currency = "GBP";
    culture = "en_GB";
    calendar.firstDayOfWeek = 1;
  };

  services.restic.backups.daily.paths = [ "/var/lib/grocy" ];
}
