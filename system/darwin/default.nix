{ inputs }:

{ system, username }:

let
  configuration = import ./configuration.nix { inherit username; };
  work = username == "haydenyoung";
in
inputs.darwin.lib.darwinSystem {
  inherit system;
  modules = [
    configuration

    inputs.home-manager.darwinModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users.${username} = import ./home-manager.nix {
        inherit inputs work;
      };
    }
  ];
}
