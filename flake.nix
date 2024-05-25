{
  description = "Hayden's Nix configuration, for NixOS and Darwin";

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://ghostty.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "ghostty.cachix.org-1:QB389yTa6gTyneehvqG58y0WnHjQOqgnA+wBnpWWxns="
    ];
  };

  inputs = {
    # Use latest unstable 23.05 Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Include `nxs` (nixpkgs-stable) and `nxt` (nixpkgs-trunk)
    stable.url = "github:nixos/nixpkgs/nixos-23.11";
    trunk.url = "github:nixos/nixpkgs";

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

    hvim = {
      url = "github:hbjydev/hvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
    ghostty-hm.url = "github:clo4/ghostty-hm-module";

    build-configs.url = "github:ALT-F4-LLC/build-configs";
    build-configs.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; }
      (toplevel@{ withSystem, ... }: {
        systems = [ "x86_64-linux" "aarch64-darwin" ];

        flake = {
          hosts = import ./nix/hosts.nix;

          darwinConfigurations = import ./nix/darwin.nix toplevel;
          nixosConfigurations = import ./nix/nixos.nix toplevel;

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
          };
      });
}
