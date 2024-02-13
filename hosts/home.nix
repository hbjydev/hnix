{ config, lib, ... }:
with builtins;
with lib;
{
  networking.extraHosts = ''
    192.168.4.1  router.home
    192.168.4.2  nas.home
  '';

  i18n.defaultLocale = mkDefault "en_GB.UTF-8";
  time.timeZone = mkDefault "Europe/London";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };
}
