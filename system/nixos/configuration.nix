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
        monospace = [ "IntelOne Mono" ];
      };
    };

    fonts = [
      inputs.nixpkgs-unstable.legacyPackages."${pkgs.system}".intel-one-mono
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

  nixpkgs.config = {
    allowUnfree = true;
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
      packages = with pkgs; [];
    };
  };
}
