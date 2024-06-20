{ withSystem, inputs, ... }:
let
  inherit (inputs) self darwin nixpkgs;
  inherit (nixpkgs) lib;

  specialArgs = type: work: username: {
    hostType = type;
    inherit work username;
    inherit (inputs)
      sops-nix
      ghostty-hm
      ghostty
      home-manager
      nixpkgs
      hvim
      build-configs
      deploy-rs
      flake-parts
      attic;
  };

  genConfiguration = hostname: { hostPlatform, type, work, username, ... }:
    withSystem hostPlatform ({ pkgs, system, ... }:
      darwin.lib.darwinSystem {
        inherit pkgs system;
        modules = [
          inputs.home-manager.darwinModules.home-manager
          {
            home-manager = {
              sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              extraSpecialArgs = specialArgs type work username;
              useGlobalPkgs = true;
              useUserPackages = true;
            };
          }
          (../hosts + "/${hostname}")
          {
            nixpkgs.pkgs = import inputs.nixpkgs {
              system = hostPlatform;
              config.allowUnfree = true;
            };
          }
        ];
        specialArgs = specialArgs type work username;
      });
in
lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "darwin") self.hosts)
