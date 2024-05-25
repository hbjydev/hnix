{ username, work, desktop, inputs }:
{ pkgs, ... }:

let
  shared-config = import ../../../home { inherit inputs work; };
  shared-packages = import ../../../home/packages.nix { inherit pkgs inputs work; };
in
{
  imports = if desktop then [
    shared-config
    (import ../../../home/modules/ghostty.nix)
  ] else [ shared-config ];

  dconf.settings =
    if desktop then {
      "org/gnome/desktop/background" = {
        "picture-uri" = "/home/${username}/.background-img";
        "picture-uri-dark" = "/home/${username}/.background-img";
        "primary-color" = "#000000000000";
        "secondary-color" = "#000000000000";
      };
      "org/gnome/desktop/screensaver" = {
        "picture-uri" = "/home/${username}/.background-img";
        "picture-uri-dark" = "/home/${username}/.background-img";
      };
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = [
          "appindicatorsupport@rgcjonas.gmail.com"
          "dash-to-dock@micxgx.gmail.com"
        ];
      };
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/wm/keybindings" = {
        switch-applications = [ ];
        switch-applications-backwards = [ ];
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backwards = [ "<Shift><Alt>Tab" ];
      };
      "org/gnome/desktop/peripherals/mouse" = {
        natural-scroll = true;
      };
    } else { };

  programs.chromium = {
    enable = desktop;
    package = pkgs.chromium;
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; } # uBlock Origin
      { id = "eimadpbcbfnmbkopoojfekhnkhdbieeh"; } # Dark Reader
      { id = "gphhapmejobijbbhgpjhcjognlahblep"; } # GNOME Shell Integration
      { id = "aeblfdkhhhdcdjpifhhbdiojplfjncoa"; } # 1Password
      { id = "ammjkodgmmoknidbanneddgankgfejfh"; } # 7TV
    ];
  };

  home.packages = shared-packages ++ pkgs.lib.optionals desktop [
    pkgs.discord
    pkgs.spotify
    pkgs.slack
    pkgs.handbrake

    pkgs.gnomeExtensions.dash-to-dock
    pkgs.gnomeExtensions.appindicator
  ];
}
