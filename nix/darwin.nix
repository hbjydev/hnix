{ withSystem, inputs, ... }:
let
  inherit (inputs) self darwin nixpkgs;
  inherit (nixpkgs) lib;

  genConfiguration = hostname: { hostPlatform, type, ... }:
    withSystem hostPlatform ({ pkgs, system, ... }:
      darwin.lib.darwinSystem {
        inherit pkgs system;
        modules = [
          (../hosts + "/${hostname}")
        ];
        specialArgs = {
          hostType = type;
          inherit (inputs)
            home-manager;
        };
      });
in
lib.mapAttrs
  genConfiguration
  (lib.filterAttrs (_: host: host.type == "darwin") self.hosts)
