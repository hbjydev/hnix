{ ... }:
let
  domain = "hayden.moe";
in
{
  imports = [ ../../mixins/nginx ];

  systemd.services.home-assistant.serviceConfig.LimitNOFILE = 4096;
  services.home-assistant = {
    enable = true;

    extraComponents = [
      "apple_tv"
      "bluetooth"
      "cast"
      "dlna_dmr"
      "github"
      "google_translate"
      "homekit"
      "homekit_controller"
      "matter"
      "met"
      "mqtt"
      "plex"
      "prometheus"
      "radarr"
      "sabnzbd"
      "sonarr"
      "spotify"
      "synology_dsm"
      "thread"
      "tuya"
      "upnp"
    ];

    config = {
      default_config = { };
      homeassistant = {
        name = "The Hole";
        unit_system = "metric";
        time_zone = "Europe/London";
        temperature_unit = "C";

        external_url = "https://hass.${domain}";
      };

      frontend = {
        themes = "!include_dir_merge_named themes";
      };

      http = {
        use_x_forwarded_for = true;
        trusted_proxies = [ "127.0.0.1" "::1" ];
      };
    };
  };

  services.nginx.virtualHosts."hass.${domain}" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://localhost:8123";
    };
  };
}
