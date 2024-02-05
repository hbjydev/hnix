set positional-arguments

sops_dir := if os() == "macos" { "$HOME/Library/Application Support/sops" } else { "$HOME/.config/sops" }

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

set-sops-admin-key *id='nsmv3qxydr2dx7pftwowrrkflm':
  #!/usr/bin/env bash
  PRIVKEY=$(op item get "{{id}}" --reveal --fields 'label=private key' | sed 's/"//' | tail -n 8 | head -n 7)
  PRIVKEYFILE=$(mktemp)
  PUBKEY=$(op item get "{{id}}" --fields 'label=public key')
  PUBKEYFILE=$(mktemp)
  mkdir -p "{{ sops_dir }}/age"
  rm -rf "{{ sops_dir }}/age/keys.txt"
  echo "$PRIVKEY" > $PRIVKEYFILE
  echo "$PUBKEY" > $PUBKEYFILE
  ssh-to-age -private-key -i $PRIVKEYFILE -o "{{ sops_dir }}/age/keys.txt"
  echo "Your AGE recipient is $(ssh-to-age -i $PUBKEYFILE)"
  rm $PRIVKEYFILE
  rm $PUBKEYFILE
