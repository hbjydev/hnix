{
  description = "Hayden's Nix configuration, for NixOS and Darwin";

  nixConfig = {
    extra-substituters = [
      # "https://cache.hayden.moe/hayden"
      "https://nix-community.cachix.org"
      "https://ghostty.cachix.org"
      "https://altf4llc-os.cachix.org"
    ];
    extra-trusted-public-keys = [
      # "hayden:11XFX2/dPhIIdk2tXAcX63EgFDSNyHfISMozZ9iw7M8="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
      "altf4llc-os.cachix.org-1:9mjdTiW005IKsaVtapDSvkbskvoQ7t4/Q5S3FsQJ/5A="
    ];
  };

  inputs = {
    # Use latest unstable 23.05 Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hvim.url = "github:hbjydev/hvim";

    ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
    ghostty.inputs.nixpkgs-stable.follows = "nixpkgs";
    ghostty.inputs.nixpkgs-unstable.follows = "nixpkgs";

    ghostty-hm.url = "github:clo4/ghostty-hm-module";

    build-configs.url = "github:ALT-F4-LLC/build-configs";
    build-configs.inputs.nixpkgs.follows = "nixpkgs";

    pkgs-nix.url = "github:ALT-F4-LLC/pkgs.nix?ref=alloy-pkg";
    pkgs-nix.inputs.nixpkgs.follows = "nixpkgs";

    attic.url = "github:zhaofengli/attic";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (toplevel@{ withSystem, ... }: {
        systems = [ "x86_64-linux" "aarch64-darwin" ];

        flake = {
          hosts = import ./nix/hosts.nix;

          darwinConfigurations = import ./nix/darwin.nix toplevel;
          nixosConfigurations = import ./nix/nixos.nix toplevel;
          homeConfigurations = import ./nix/linux.nix toplevel;

          deploy = import ./nix/deploy.nix toplevel;

          overlays = import ./nix/overlay.nix toplevel;
        };

        perSystem = { pkgs, ... }:
          let
            inherit (pkgs) just ssh-to-age;
          in
          {
            devShells.default = pkgs.mkShell {
              buildInputs = [ just ssh-to-age ];
            };
            packages.atp-pds = pkgs.callPackage ./pkgs/atp-pds/default.nix {};
          };
      });
}
