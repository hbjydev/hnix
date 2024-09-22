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

  genConfiguration = hostname: { address, hostPlatform, homeDirectory, type, work, username, ... }:
    withSystem hostPlatform ({ ... }:
      inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = import inputs.nixpkgs {
          system = hostPlatform;
          config.allowUnfree = true;
        };
        modules = [
          inputs.sops-nix.homeManagerModules.sops 
          {
            home.homeDirectory = homeDirectory;
          }
          (../hosts + "/${hostname}")
        ];

        extraSpecialArgs = specialArgs address type work username;
      });
in
lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "home-manager") inputs.self.hosts)
