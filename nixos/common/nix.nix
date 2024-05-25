{ pkgs, nixpkgs, ... }:
{
  imports = [ ../../shared/nix.nix ];

  environment.etc."nix/inputs/nixpkgs".source = "${nixpkgs}";

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
