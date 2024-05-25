{ inputs, lib, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.sops-nix.nixosModules.sops

    ../nixos/mixins/nix.nix
  ] ++ (lib.my.mapModulesRec' (toString ../modules) import);

  programs._1password.enable = true;

  programs.zsh.enable = true;

  sops = {
    defaultSopsFile = ../secrets/global.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };

  system.stateVersion = "24.05";
}
