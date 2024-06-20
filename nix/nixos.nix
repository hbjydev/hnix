{ withSystem, inputs, ... }:

let
  inherit (inputs.nixpkgs) lib;

  specialArgs = addr: type: work: username: {
    hostAddress = addr;
    hostType = type;
    inherit work username;
    inherit (inputs)
      pkgs-nix
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

  genConfiguration = hostname: { address, hostPlatform, type, work, username, ... }:
    withSystem hostPlatform ({ ... }:
      lib.nixosSystem {
        modules = [
          inputs.home-manager.nixosModules.home-manager
          {
            home-manager = {
              sharedModules = [ inputs.sops-nix.homeManagerModules.sops ];
              extraSpecialArgs = specialArgs address type work username;
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

        specialArgs = specialArgs address type work username;
      });
in
lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "nixos") inputs.self.hosts)
