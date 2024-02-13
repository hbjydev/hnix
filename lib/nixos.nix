{ inputs, lib, pkgs, ... }:
let
  inherit (lib) mkDefault;
  inherit (lib.my) mapModules;
  inherit (lib.strings) removeSuffix;

  sys = "x86_64-linux";
in
rec {
  mkHost = path: attrs @ { system ? sys, ... }:
    lib.nixosSystem {
      inherit system;
      specialArgs = { inherit lib inputs system; };
      modules = [
        {
          nixpkgs.pkgs = pkgs;
          networking.hostName = mkDefault (removeSuffix ".nix" (baseNameOf path));
        }
        (import path)
      ];
    };

  mapHosts = dir: attrs @ { system ? system, ... }:
    mapModules dir
      (hostPath: mkHost hostPath attrs);
}
