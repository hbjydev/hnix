set positional-arguments

sops_dir := if os() == "macos" { "$HOME/Library/Application Support/sops" } else { "$HOME/.config/sops" }

[macos]
rebuild profile='work':
  darwin-rebuild switch --flake ".#{{ profile }}"

[linux]
rebuild profile='':
  #!/usr/bin/env bash
  profile="{{profile}}"
  if [[ "$profile" = "" ]]; then
    profile="$(hostname)"
  fi
  sudo nixos-rebuild switch --flake ".#$profile"

update:
  nix flake update

lint path=".":
  nix develop -c nixpkgs-fmt --check {{path}}

format path=".":
  nix develop -c nixpkgs-fmt {{path}}

[confirm("This will delete the contents of {{sops_dir}}/age/keys.txt, are you sure?")]
set-sops-admin-key *id='nsmv3qxydr2dx7pftwowrrkflm':
  #!/usr/bin/env bash
  set -euo pipefail
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
