{ username ? "hayden", config, hostType, sops-nix, ... }:
if hostType == "nixos" || hostType == "darwin" then {
  imports = [
    (
      if hostType == "nixos" then ./nixos.nix
      else if hostType == "darwin" then ./darwin.nix
      else throw "no sysconfig for hostType '${hostType}'"
    )
  ];
  home-manager.users.${username} = {
    imports = [
      ./core
      ./dev
    ];
    home.username = config.users.users.${username}.name;
  };
}
else throw "Unknown hostType '${hostType}'"
