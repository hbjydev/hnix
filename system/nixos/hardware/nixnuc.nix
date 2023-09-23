# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  services.xserver.videoDrivers = [ "displaylink" "modesetting" ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/f8948e68-b255-4173-b824-6d7f10d21c39";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/D629-8B4D";
      fsType = "vfat";
    };

  fileSystems."/storage" =
    { device = "/dev/disk/by-uuid/20cbe703-a000-4b7d-98f0-eae0ca6571e3";
      fsType = "ext4";
    };

  swapDevices =
    [ { device = "/dev/disk/by-uuid/99c2f4f1-420b-4435-9350-0d3b75e92b8a"; }
    ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno1.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlp0s20f3.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.bluetooth.enable = true;

  services.home-assistant = {
    enable = true;
    extraComponents = [
      "tuya"
      "apple_tv"
      "met"
      "radarr"
      "sonarr"
      "sabnzbd"
      "cast"
      "plex"
      "homekit"
      "homekit_controller"
    ];
    config = {
      default_config = {};
      homeassistant = {
        name = "The Hole";
        unit_system = "metric";
        time_zone = "Europe/London";
        temperature_unit = "C";
      };
    };
  };

  services.fwupd.enable = true;

  nixpkgs.config.packageOverrides = pkgs: {
    vaapiIntel = pkgs.vaapiIntel.override { enableHybridCodec = true; };
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      twingate-connector = {
        autoStart = true;
        image = "twingate/connector:1";
        environment = {
          TWINGATE_NETWORK = "kuraudo";
          TWINGATE_ACCESS_TOKEN = "eyJhbGciOiJFUzI1NiIsImtpZCI6IjZmd1FHNV81TGRnQVBxcGM0UW1GNWprWk84X1dWSXpOVXIxZkZlNEkxNkUiLCJ0eXAiOiJEQVQifQ.eyJudCI6IkFOIiwiYWlkIjoiMTU3Mjk1IiwiZGlkIjoiOTQ2MTAwIiwianRpIjoiMTNmOGVhNDEtZWViYy00ZTViLWE3NzYtOWRjYWY2ZTRmMGI3IiwiaXNzIjoidHdpbmdhdGUiLCJhdWQiOiJrdXJhdWRvIiwiZXhwIjoxNjk1NDA5MTMwLCJpYXQiOjE2OTU0MDU1MzAsInZlciI6IjQiLCJ0aWQiOiI1Mzc1NyIsInJudyI6MTY5NTQwNTgzMCwicm5ldGlkIjoiNjY4MzUifQ.0bYn4vQFrdIssKx2GGFPQmup_Z_PuasEFXvI9WoMbqDpDZ8zASFyTCYBdMOIBgOk5ofh0s3bg-nUcAmiqYsJ3w";
          TWINGATE_REFRESH_TOKEN = "vsWtWy1z0envHdz8nJ7ot3E5ow_gLf7Z5Emc20IsGQxY3Fx2PWB4KV-y0sQDlOJT5LnPBryTogiXgGGjsW3jY4WdwfsU3NTC54ZUwpg7hjABeX0qfuGjPIxKZxdZeX1ZQcIvjA";
          TWINGATE_LABEL_HOSTNAME = "nixnuc-nixos";
        };
      };
    };
  };
}
