{ desktop, lib, ... }:
{
  imports = lib.optionals desktop [ ./graphical ];
}
