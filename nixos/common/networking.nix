{ lib, ... }:
{
  networking.firewall.enable = false;
  networking.networkmanager.enable = lib.mkDefault false;
}
