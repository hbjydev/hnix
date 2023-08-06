# `dots.nix`

My dotfiles, rewritten in Nix (mostly).

## Installation

### NixOS

On NixOS, simply clone the repo to `/etc/nixos` and run:

```shell
sudo nixos-rebuild switch --flake '/etc/nixos#personal-nixos'
```

### macOS

On macOS, first install nix-darwin:

```shell
sh <(curl -L https://nixos.org/nix/install)
git clone https://github.com/hbjydev/dots.nix.git ~/.config/nix
nix run nix-darwin -- switch --flake '~/.config/nix#personal-darwin'
```
