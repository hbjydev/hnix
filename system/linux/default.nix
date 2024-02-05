{ inputs }:

{ system
, username
, homeDirectory ? "/home/${username}"
, work ? false
, wsl ? false
}:
inputs.home-manager.lib.homeManagerConfiguration {
  pkgs = inputs.nixpkgs.legacyPackages.${system};

  imports = [
    inputs.sops-nix.homeManagerModules.sops
  ];

  modules = [
    (import ./home-manager.nix { inherit inputs username homeDirectory work wsl; })
  ];
}
