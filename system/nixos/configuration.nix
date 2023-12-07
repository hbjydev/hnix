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

  programs._1password.enable = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  time.timeZone = "Europe/London";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  networking = {
    firewall.enable = false;
    hostName = hostname;
    networkmanager.enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  system.stateVersion = "23.05";

  programs.zsh.enable = true;

  users = {
    defaultUserShell = pkgs.zsh;

    users."${username}" = {
      extraGroups = [ "wheel" ];
      home = "/home/${username}";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkhuhfzyg7R+O62XSktHufGmmhy6FNDi/NuPPJt7bI+"
      ];
    };
  };

  sops = {
    defaultSopsFile = ../../secrets/global.yaml;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
  };
}
