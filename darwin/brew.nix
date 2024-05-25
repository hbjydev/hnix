{ ... }:
{
  homebrew = {
    enable = true;

    brews = [ "mas" ];

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
