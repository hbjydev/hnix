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

  outputs = inputs@{ flake-parts, self, ... }:
    let
      systems = import ./system { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [ nixpkgs-fmt ];
        };
      };

      flake = {
        homeConfigurations = {
          wsl = systems.mkLinux {
            system = "x86_64-linux";
            username = "hayden";
            wsl = true;
          };
        };

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

        nixosConfigurations = {
          vm-nixos = systems.mkNixOS {
            desktop = true;
            system = "x86_64-linux";
            username = "hayden";
            hostname = "nixos-vm";
            options = [ "docker" "x" ];
          };
          nixnuc-nixos = systems.mkNixOS {
            desktop = true;
            system = "x86_64-linux";
            username = "hayden";
            hostname = "nixnuc";
            options = [ "firefly" "docker" "downloads" "ssh" "x" ];
          };
        };
      };
    };
}
