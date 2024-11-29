{ desktop, lib, ... }:
{
  imports = lib.optionals desktop [ ./graphical ];

  news.display = "silent";
  programs.home-manager.enable = true;
}
