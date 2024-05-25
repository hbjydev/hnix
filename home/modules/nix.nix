{ inputs, ... }:
{
  nix.registry = {
    nx.flake = inputs.nixpkgs;
  };
}
