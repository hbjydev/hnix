{ username }:

{ config, pkgs, ... }:
{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    layout = "gb";
    xkbVariant = "";

    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };

    excludePackages = with pkgs; [
      xterm
    ];

    desktopManager.gnome.enable = true;
  };

  environment.gnome.excludePackages = (with pkgs; [
    gnome-photos
    gnome-tour
    gnome-console
  ] ++ (with pkgs.gnome; [
    cheese # webcam tool
    gnome-music
    gnome-terminal
    gnome-maps
    gnome-calendar
    gedit # text editor
    epiphany # web browser
    geary # email reader
    evince # document viewer
    gnome-characters
    totem # video player
    tali # poker game
    iagno # go game
    hitori # sudoku game
    atomix # puzzle game
    yelp
  ]));

  # Fonts config
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

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Configure console keymap
  console.keyMap = "uk";

  # Enable sound with pipewire.
  sound.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  programs._1password-gui.polkitPolicyOwners = [ username ];
  programs._1password-gui.enable = true;

  nixpkgs.config.pulseaudio = true;

  users.users."${username}".extraGroups = [ "audio" ];
}
