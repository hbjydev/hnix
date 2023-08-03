{
  description = "Hayden's Nix configuration, for NixOS and Darwin";

  inputs = {
    home-manager.url = "github:nix-community/home-manager";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
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
