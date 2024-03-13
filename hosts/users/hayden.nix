{ inputs, pkgs, ... }:
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];

  users = {
    defaultUserShell = pkgs.zsh;

    users.hayden = {
      extraGroups = [ "wheel" "docker" ];
      home = "/home/hayden";
      isNormalUser = true;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDkhuhfzyg7R+O62XSktHufGmmhy6FNDi/NuPPJt7bI+"
      ];
    };
  };

  home-manager = {
    sharedModules = [
      inputs.sops-nix.homeManagerModules.sops
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hayden = import ../home-manager.nix {
      inherit inputs;
      desktop = true;
      work = false;
      username = "hayden";
    };
  };
}
