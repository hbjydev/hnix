{ inputs }:
{ ... }:
{
  nix.registry = {
    nx.flake = inputs.nixpkgs;
    nxs.flake = inputs.stable;
    nxt.flake = inputs.trunk;
  };
}
