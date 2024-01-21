{ inputs, work }:

{ pkgs, ... }:

let
  oxocarbon = (import ../shared/oxocarbon.nix).dark;
  shared-config = import ../shared/home-manager.nix { inherit inputs work; };
  shared-packages = import ../shared/home-manager-packages.nix { inherit pkgs inputs work; };
in
{
  imports = [ shared-config (import ../shared/modules/kitty.nix) ];

  home.file."Library/Application Support/k9s/skin.yml".source = ../../config/k9s/skin.yml;

  home.packages = shared-packages ++ [ ];
}
