{ desktop, lib, ... }:
{
  imports = lib.optionals desktop [ ./graphical ];

  news.display = false;
  programs.home-manager.enable = true;
}
