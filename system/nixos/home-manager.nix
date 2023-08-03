{ work, desktop, inputs }:

{ pkgs, ... }:

let
  shared-config = import ../shared/home-manager.nix { inherit inputs work; };
  shared-packages = import ../shared/home-manager-packages.nix { inherit pkgs; };
in
{
  imports = if desktop then [ shared-config ] else [ shared-config ];

  home.packages = shared-packages ++ pkgs.lib.optionals desktop [
    pkgs.discord
    pkgs.spotify
  ];
}
