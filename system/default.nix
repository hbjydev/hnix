{ inputs }: {
  mkNixOS = import ./nixos { inherit inputs; };
}
