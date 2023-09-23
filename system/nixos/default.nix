{ inputs }:

{ desktop, system, username, hostname, options }:

let
  hardware-configuration = import ./hardware/${hostname}.nix;
  configuration = import ./configuration.nix {
    inherit inputs desktop username hostname options;
  };
  work = username == "haydenyoung";
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    hardware-configuration
    configuration

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = import ./home-manager.nix {
        inherit desktop inputs work;
      };
    }
  ];
}
