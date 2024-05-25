{ sops-nix, ... }:
{
  imports = [
    sops-nix.nixosModules.sops

    ./boot-efi.nix
    ./locale.nix
    ./networking.nix
    ./nix.nix
    ./security.nix
  ];

  programs.zsh.enable = true;

  sops.age = {
    sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    keyFile = "/var/lib/sops-nix/key.txt";
    generateKey = true;
  };

  system.stateVersion = "24.05";
}
