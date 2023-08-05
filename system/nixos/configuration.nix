{ inputs, desktop, username }:

{ pkgs, ... }:

let
  configuration-desktop = import ./configuration-desktop.nix { inherit username; };
in
{
  imports = if desktop then [ configuration-desktop ] else [ ];

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  programs._1password.enable = true;
  programs._1password-gui.enable = true;

  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [ "IntoneMono Nerd Font" ];
      };
    };

    packages = [
      pkgs.nerdfonts
    ];
  };

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

  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
        "https://devenv.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      ];
      trusted-users = [ "@wheel" ];
      warn-dirty = false;
    };
  };

  nixpkgs.config = {
    allowUnfree = true;
    pulseaudio = if desktop then true else false;
  };

  networking = {
    firewall.enable = false;
    hostName = "${username}-nixos";
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
      extraGroups = [ "wheel" ] ++ pkgs.lib.optionals desktop [ "audio" ];
      home = "/home/${username}";
      isNormalUser = true;
      packages = with pkgs; [ wl-clipboard ];
    };
  };

  virtualisation = {
    containerd = {
      enable = true;
      settings =
        let
          fullCNIPlugins = pkgs.buildEnv {
            name = "full-cni";
            paths = with pkgs; [ cni-plugin-flannel cni-plugins ];
          };
        in
        {
          plugins."io.containerd.grpc.v1.cri".cni = {
            bin_dir = "${fullCNIPlugins}/bin";
            conf_dir = "/var/lib/rancher/k3s/agent/etc/cni/net.d/";
          };
        };
    };

    podman = {
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      enable = true;
      extraPackages = with pkgs; [ zfs ];
    };
  };
}
