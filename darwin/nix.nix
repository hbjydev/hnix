{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  services.nix-daemon.enable = true;

  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = false;
      builders-use-substitutes = false;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://ghostty.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      ];
      trusted-users = [ "@staff" "hayden" "haydenyoung" ];
      warn-dirty = false;
    };
  };
}
