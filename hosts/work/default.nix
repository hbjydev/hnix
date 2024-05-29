{ home-manager, ... }:
{
  imports = [
    home-manager.darwinModules.home-manager
    ../../darwin
    ../../users/hayden
  ];
}
