{ inputs, pkgs, ... }:
{
  home.packages = [
    inputs.ghostty.packages.${pkgs.system}.default
  ];
}
