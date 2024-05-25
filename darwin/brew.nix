{ pkgs, lib, ... }:
{
  environment = {
    systemPackages = [
      pkgs.coreutils
      pkgs.findutils
      pkgs.gawk
      pkgs.git
      pkgs.gnugrep
      pkgs.gnused
      pkgs.gnutar
      pkgs.gnutls
      pkgs.ncurses
      pkgs.openssh
    ];
    systemPath = lib.mkBefore [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
    variables = {
      SHELL = lib.getExe pkgs.zsh;
    };
  };

  homebrew = {
    enable = true;

    onActivation = {
      cleanup = "zap";
      autoUpdate = true;
      upgrade = true;
    };

    brews = [ "git" "mas" ];

    casks = [
      "arc"
      "discord"
      "element"
      "httpie"
      "notion"
      "orbstack"
      "raycast"
      "spotify"
      "microsoft-teams"
      "slack"
      "amazon-chime" # Comms
    ];

    masApps = {
      # Safari Extentions
      "1Password for Safari" = 1569813296;
      "Dark Reader for Safari" = 1438243180;

      # Applications
      Keynote = 409183694;
      "Yubico Authenticator" = 1497506650;
    };
  };
}
