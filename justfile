nixos profile command:
  sudo nixos-rebuild {{ command }} --flake ".#{{ profile }}-nixos"

darwin profile command:
  darwin-rebuild {{ command }} --flake ".#{{ profile }}-darwin"

linux profile command:
  home-manager {{ command }} --flake ".#{{ profile }}"

update:
  nix flake update

lint path=".":
  nix develop -c nixpkgs-fmt --check {{path}}

format path=".":
  nix develop -c nixpkgs-fmt {{path}}
