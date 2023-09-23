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
    desktopManager.gnome.enable = true;
  };

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
