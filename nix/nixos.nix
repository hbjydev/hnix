{ withSystem, inputs, ... }:

let
  inherit (inputs.nixpkgs) lib;

  genConfiguration = hostname: { address, hostPlatform, type, ... }:
    withSystem hostPlatform ({ ... }:
      lib.nixosSystem {
        modules = [
          (../hosts + "/${hostname}")
          {
            nixpkgs.pkgs = import inputs.nixpkgs {
              system = hostPlatform;
              config.allowUnfree = true;
            };
          }
        ];

        specialArgs = {
          hostAddress = address;
          hostType = type;
          inherit (inputs)
            sops-nix
            ghostty-hm
            ghostty
            home-manager
            nixpkgs
            hvim
            build-configs
            deploy-rs;
        };
      });
in
lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "nixos") inputs.self.hosts)
