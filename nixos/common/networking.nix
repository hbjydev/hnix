{ lib, ... }:
{
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  networking.networkmanager.enable = lib.mkDefault false;
}
