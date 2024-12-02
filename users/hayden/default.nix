{ username ? "hayden", config, hostType, ... }:
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
    home.username = (
      if hostType != "home-manager" then config.users.users.${username}.name
      else username
    );
  };
} else if hostType == "home-manager" then {
    imports = [ ./core ./dev ./linux.nix ];
    home.username = username;
}
else throw "Unknown hostType '${hostType}'"
