{ config, ... }:
{
  imports = [ ];

  sops.secrets = {
    "firefly_app_env" = {
      sopsFile = ../../../secrets/firefly.yaml;
      restartUnits = [ "docker-firefly-app.service" ];
    };

    "firefly_importer_env" = {
      sopsFile = ../../../secrets/firefly.yaml;
      restartUnits = [ "docker-firefly-importer.service" ];
    };
  };

  virtualisation.oci-containers.containers = {
    firefly-app = {
      autoStart = true;
      image = "fireflyiii/core:version-6.1.6";
      environmentFiles = [
        config.sops.secrets.firefly_app_env.path
      ];
      ports = [ "8642:8080" ];
      volumes = [
        "/storage/firefly/upload:/var/www/html/storage/upload"
        "/storage/firefly/database:/var/www/html/storage/database"
      ];
    };

    firefly-importer = {
      autoStart = true;
      image = "fireflyiii/data-importer:version-1.4.1";
      environmentFiles = [
        config.sops.secrets.firefly_importer_env.path
      ];
      ports = [ "8643:8080" ];
    };

    #firefly-cron = {
    #  autoStart = true;
    #  image = "alpine";
    #  environmentFiles = [
    #    config.sops.secrets.firefly_app_env.path
    #  ];
    #};
  };
}
