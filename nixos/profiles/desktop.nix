{ pkgs, ... }:
{
  imports = [ ../common ];

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;

    xkb = {
      layout = "gb";
      variant = "";
    };

    displayManager.gdm = {
      enable = true;
      autoSuspend = false;
    };

    excludePackages = with pkgs; [
      xterm
    ];

    desktopManager.gnome.enable = true;
  };

  services.xrdp = {
    enable = true;
    defaultWindowManager = "/run/current-system/sw/bin/gnome-session";
  };

  environment.systemPackages = with pkgs; [
    gnome.gnome-session
    wl-clipboard
    xclip
    element-desktop
  ];

  environment.gnome.excludePackages = (
    (with pkgs; [
      gnome-photos
      gnome-tour
      gnome-console
      gedit # text editor
    ])
    ++
    (with pkgs.gnome; [
      cheese # webcam tool
      gnome-music
      gnome-terminal
      gnome-maps
      gnome-calendar
      #epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
      yelp
    ])
  );

  # Fonts config
  fonts = {
    fontconfig = {
      enable = true;

      defaultFonts = {
        monospace = [ "IntoneMono Nerd Font" ];
      };
    };

    packages = [
      (pkgs.nerdfonts.override {
        fonts = [ "GeistMono" ];
      })
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

  programs._1password-gui.polkitPolicyOwners = [ "hayden" ];
  programs._1password-gui.enable = true;

  users.users.hayden.extraGroups = [ "audio" ];

  security.sudo.wheelNeedsPassword = false;
}
