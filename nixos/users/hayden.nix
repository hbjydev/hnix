{ desktop ? true, work ? false }:
{ deploy-rs, build-configs, hvim, ghostty-hm, ghostty, home-manager, sops-nix, nixpkgs, pkgs, ... }:
{
  imports = [
    home-manager.nixosModules.home-manager
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
      sops-nix.homeManagerModules.sops
    ];
    useGlobalPkgs = true;
    useUserPackages = true;
    users.hayden = import ../mixins/home-manager {
      inherit desktop work;
      inputs = {
        inherit
        build-configs
        home-manager
        sops-nix
        ghostty-hm
        ghostty
        hvim
        nixpkgs
        deploy-rs;
      };
      username = "hayden";
    };
  };
}
