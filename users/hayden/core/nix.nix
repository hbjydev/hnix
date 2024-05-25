{ nixpkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  nix.registry = {
    nx.flake = nixpkgs;
  };
}
