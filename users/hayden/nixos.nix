{ config, pkgs, lib, ... }:
let
  inherit (lib) optionals;
in
{
  users.users.hayden = {
    createHome = true;
    description = "Hayden Young";
    extraGroups = [ "wheel" ]
      ++ optionals config.hardware.i2c.enable [ "i2c" ]
      ++ optionals config.networking.networkmanager.enable [ "networkmanager" ]
      ++ optionals config.services.xserver.enable [ "input" "video" ]
      ++ optionals config.sound.enable [ "audio" ]
      ++ optionals config.virtualisation.docker.enable [ "docker" ]
      ++ optionals config.virtualisation.libvirtd.enable [ "libvirtd" ]
      ++ optionals config.virtualisation.podman.enable [ "podman" ];
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkhuhfzyg7R+O62XSktHufGmmhy6FNDi/NuPPJt7bI+"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdUGldjr+KGTEcc1XHlpNGRSvBeuPH2fBJz27+28Klw"
    ];
    shell = pkgs.zsh;
  };

  programs._1password-gui.polkitPolicyOwners = [ "hayden" ];

  home-manager.users.hayden = {
    imports = optionals config.services.xserver.enable [
      ./graphical
    ];
  };
}
