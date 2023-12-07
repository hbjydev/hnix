{ inputs }:

{ desktop, system, username, hostname, options }:

let
  hardware-configuration = import ./hardware/${hostname}.nix;
  configuration = import ./configuration.nix {
    inherit inputs desktop username hostname options;
  };
  work = username == "haydenyoung";
  inherit (inputs) sops-nix;
in
inputs.nixpkgs.lib.nixosSystem {
  inherit system;
  specialArgs = {
    trunk = (import inputs.trunk) {
      inherit system;
      config = { allowUnfree = true; };
    };
  };
  modules = [
    hardware-configuration
    configuration

    sops-nix.nixosModules.sops

    inputs.home-manager.nixosModules.home-manager
    {
      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.users."${username}" = import ./home-manager.nix {
        inherit desktop inputs work username;
      };
    }
  ];
}
