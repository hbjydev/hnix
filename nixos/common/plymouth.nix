{ pkgs, ... }:
let
  themePkg = pkgs.adi1090x-plymouth-themes.override { selected_themes = [ "loader_2" ]; };
in
{
  boot.plymouth.enable = true;
  boot.plymouth.theme = "loader_2";
  boot.plymouth.themePackages = [themePkg];
}
