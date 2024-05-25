{ username, pkgs, ... }:
{
  home-manager.users.${username} = {
    imports = [];
  };

  users.users.${username} = {
    createHome = true;
    description = "Hayden Young";
    home = "/Users/${username}";
    isHidden = false;
    shell = pkgs.zsh;
  };
}
