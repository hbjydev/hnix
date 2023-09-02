{
  description = "Hayden's Nix configuration, for NixOS and Darwin";

  inputs = {
    # Use latest unstable 23.05 Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "https://flakehub.com/f/nix-community/home-manager/0.1.*.tar.gz";
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
        packages = {
          hbjy-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "hbjy";
            src = ./config/nvim;
          };
        };
      };

      flake = {
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
          personal-nixos = systems.mkNixOS {
            desktop = true;
            system = "x86_64-linux";
            username = "hayden";
          };
	      };
      };
    };
}
