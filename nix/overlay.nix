{ inputs, ... }:
let
  inherit (inputs.nixpkgs) lib;
in
{
  default = lib.composeManyExtensions [
    inputs.deploy-rs.overlays.default
  ];
}
