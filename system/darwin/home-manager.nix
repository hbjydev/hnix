{ inputs, work }:

{ pkgs, ... }:

let
  oxocarbon = (import ../../home/oxocarbon.nix).dark;
  shared-config = import ../../home { inherit inputs work; };
  shared-packages = import ../../home/packages.nix { inherit pkgs inputs work; };
in
{
  imports = [ shared-config (import ../../home/modules/kitty.nix) ];

  home.file."Library/Application Support/k9s/skin.yml".source = ../../config/k9s/skin.yml;

  home.packages = shared-packages ++ [ ];
}
