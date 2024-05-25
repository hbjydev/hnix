{ ... }:
{
  imports = [
    ./brew.nix
    ./fonts.nix
  ];

  system.defaults = {
    NSGlobalDomain = {
      AppleFontSmoothing = 1;
      AppleShowAllExtensions = true;
      AppleKeyboardUIMode = 3;
    };
    dock = {
      autohide = true;
      tilesize = 46;
    };
  };

  environment.pathsToLink = [ "/share/qemu" ];
  programs.zsh.enable = true;
  security.pam.enableSudoTouchIdAuth = true;
  nixpkgs.config.allowUnfree = true;
  services.nix-daemon.enable = true;
  system.stateVersion = 4;
}
