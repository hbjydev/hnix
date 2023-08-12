{ username }:

{ pkgs, ... }:

{
  nix = {
    package = pkgs.nixUnstable;

    settings = {
      auto-optimise-store = false;
      builders-use-substitutes = false;
      experimental-features = [ "nix-command" "flakes" ];
      substituters = [
        "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
      trusted-users = [ "@staff" ];
      warn-dirty = false;
    };
  };

  nixpkgs = {
    config.allowUnfree = true;
  };

  fonts = {
    fontDir.enable = true;
    fonts = [
      # pkgs.intel-one-mono
      pkgs.nerdfonts
    ];
  };

  homebrew = {
    enable = true;

    brews = [ "mas" ];

    casks = [
      "iterm2"
      "spotify"
      "discord"
      "alfred"
      "notion"
      "dbeaver-community"
    ] ++ (
      # Handle work environment desktop packages
      if username == "haydenyoung"
        then [
          "microsoft-teams" "slack" "amazon-chime" # Comms
        ]
        else [
          "linear"
        ]
    );

    masApps = {
      # Safari Extentions
      "1Password for Safari" = 1569813296;
      "Dark Reader for Safari" = 1438243180;

      # Applications
      Keynote = 409183694;
      "Yubico Authenticator" = 1497506650;
    };
  };

  environment.pathsToLink = ["/share/qemu"];

  programs.zsh.enable = true;

  services.nix-daemon.enable = true;

  system.stateVersion = 4;

  security.pam.enableSudoTouchIdAuth = true;

  users.users.${username}.home = "/Users/${username}";
}
