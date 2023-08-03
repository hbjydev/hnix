{
  description = "Hayden's Nix configuration, for NixOS and Darwin";

  inputs = {
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/release-23.05";

    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.05";
  };

  outputs = inputs@{ flake-parts, self, ... }:
    let
      systems = import ./system { inherit inputs; };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages = {
          hbjy-nvim = pkgs.vimUtils.buildVimPlugin {
            name = "hbjy";
            src = ./config/nvim;
          };
        };
      };

      flake = {
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
