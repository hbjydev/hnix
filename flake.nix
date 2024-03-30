{
  description = "Hayden's Nix configuration, for NixOS and Darwin";

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
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

    ghostty.url = "git+ssh://git@github.com/mitchellh/ghostty";
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
    pkgsLinux_x86 = mkPkgs nixpkgs [] "x86_64-linux";
    pkgsDarwin_arm = mkPkgs nixpkgs [] "aarch64-darwin";

    lib = nixpkgs.lib.extend
      (self: super: { my = import ./lib { inherit inputs; pkgs = pkgsLinux_x86; lib = self; }; });
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
