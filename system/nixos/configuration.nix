{ inputs, desktop, username, hostname, options }:

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./modules/boot.nix
      ./modules/nix.nix
    ] # Standard ('required') modules
    ++ lib.lists.forEach options (opt:
      if opt == "x"
      then (import ./modules/x.nix { inherit username; })
      else if opt == "docker"
      then (import ./modules/docker.nix { inherit username; })
      else ./modules/${opt}.nix
    ); # Opt-in modules

  networking = {
    firewall.enable = false;
  };
}
