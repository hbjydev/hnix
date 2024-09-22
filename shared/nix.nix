{ hostType, lib, pkgs, nixpkgs, flake-parts, ... }:
{
  nix = {
    package = pkgs.nixVersions.latest;

    registry = {
      nixpkgs.flake = nixpkgs;
      nx.flake = nixpkgs;
      flake-parts.flake = flake-parts;
    };

    settings = {
      accept-flake-config = true;
      auto-optimise-store = hostType == "nixos";
      allowed-users = [ "@wheel" ];
      build-users-group = "nixbld";
      builders-use-substitutes = true;
      trusted-users = [ "root" "@wheel" ] ++ (lib.optionals (hostType == "darwin") [ "haydenyoung" ]);
      sandbox = hostType == "nixos";
      substituters = [
        # "https://cache.hayden.moe/hayden"
        "https://nix-community.cachix.org"
        "https://ghostty.cachix.org"
        "https://altf4llc-os.cachix.org"
      ];
      trusted-public-keys = [
        # "hayden:11XFX2/dPhIIdk2tXAcX63EgFDSNyHfISMozZ9iw7M8="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
        "altf4llc-os.cachix.org-1:9mjdTiW005IKsaVtapDSvkbskvoQ7t4/Q5S3FsQJ/5A="
      ];
      cores = 0;
      max-jobs = "auto";
      experimental-features = [
        "auto-allocate-uids"
        "configurable-impure-env"
        "flakes"
        "nix-command"
      ];
      connect-timeout = 5;
      http-connections = 0;
      flake-registry = "/etc/nix/registry.json";
    };

    distributedBuilds = true;
    extraOptions = ''
      !include tokens.conf
    '';
  } // lib.optionalAttrs (hostType == "nixos") {
    channel.enable = false;
    daemonCPUSchedPolicy = "batch";
    daemonIOSchedPriority = 5;
    nixPath = [ "nixpkgs=/run/current-system/nixpkgs" ];
    optimise = {
      automatic = true;
      dates = [ "03:00" ];
    };
  } // lib.optionalAttrs (hostType == "darwin") {
    nixPath = [ "nixpkgs=/run/current-system/sw/nixpkgs" ];
    daemonIOLowPriority = false;
  };
}
