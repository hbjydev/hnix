nixos profile command:
  sudo nixos-rebuild {{ command }} --flake ".#{{ profile }}-nixos"

darwin profile command:
  darwin-rebuild {{ command }} --flake ".#{{ profile }}-nixos"
