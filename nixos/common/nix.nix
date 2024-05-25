{ pkgs, lib, inputs, ... }:
{
  environment.etc."nix/inputs/nixpkgs".source = "${inputs.nixpkgs}";

  nix = {
    package = pkgs.nixUnstable;
    
    channel.enable = false;
    registry.nixpkgs.flake = inputs.nixpkgs;

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "auto-allocate-uids"
        "cgroups"
        "configurable-impure-env"
      ];

      substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];

      auto-optimise-store = true;
      builders-use-substitutes = true;
      auto-allocate-uids = true;
      system-features = [ "uid-range" ];

      nix-path = lib.mkForce "nixpkgs=/etc/nix/inputs/nixpkgs";
      trusted-users = [ "root" "@wheel" ];
      allowed-users = [ "root" "@wheel" ];
      warn-dirty = false;
    };
  };

  # Allow running of AppImage files without needing appimage-run
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
    magicOrExtension = ''\x7fELF....AI\x02'';
  };
}
