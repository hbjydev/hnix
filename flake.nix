{
  description = "Hayden's Nix configuration, for NixOS and Darwin";

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

    nix-index = {
      url = "github:nix-community/nix-index";
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
  };

  outputs = inputs@{ self, nixpkgs, ... }:
  let
    inherit (lib.my) mapHosts;

    systems = (import ./system { inherit inputs; });

    mkPkgs = pkgs: extraOverlays: system: import pkgs {
      inherit system;
      config = {
        allowUnfree = true;
        packageOverrides = super: {
          vaapiIntel = super.vaapiIntel.override { enableHybridCodec = true; };
        };
        permittedInsecurePackages = [
          "openssl-1.1.1w"
        ];
        pulseaudio = true;
      };
      overlays = extraOverlays ++ (lib.attrValues self.overlays);
    };
    pkgs = mkPkgs nixpkgs [] "x86_64-linux";

    lib = nixpkgs.lib.extend
      (self: super: { my = import ./lib { inherit pkgs inputs; lib = self; }; });
  in
  {
    overlays = {};

    darwinConfigurations = {
      personal-darwin = systems.mkDarwin {
        system = "aarch64-darwin";
        username = "hayden";
      };
      work-darwin = systems.mkDarwin {
        system = "aarch64-darwin";
        username = "haydenyoung";
      };
    };

    nixosConfigurations = mapHosts ./hosts {};
  };
}
