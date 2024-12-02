{ config, ... }:
let
  secret = name: config.sops.secrets."restic_${name}".path;
in
{
  sops.secrets.restic_env.restartUnits = [ "restic-backups-daily.service" ];
  sops.secrets.restic_repo.restartUnits = [ "restic-backups-daily.service" ];
  sops.secrets.restic_password.restartUnits = [ "restic-backups-daily.service" ];

  services.restic.backups.daily = {
    initialize = true;
    environmentFile = secret "env";
    repositoryFile = secret "repo";
    passwordFile = secret "password";
    paths = [ "/etc" ];
    pruneOpts = [
      "--keep-daily 7"
    ];
  };
}
