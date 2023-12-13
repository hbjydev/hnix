{ username, homeDirectory, work, inputs, wsl }:

{ pkgs, ... }:

let
  shared-config = import ../shared/home-manager.nix { inherit inputs work wsl; };
  shared-packages = import ../shared/home-manager-packages.nix { inherit pkgs inputs work; };
in
{
  imports = [ shared-config ];

  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = false;
      builders-use-substitutes = false;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  home = {
    inherit username homeDirectory;
    packages = shared-packages;
  };

  programs.home-manager.enable = true;
}
