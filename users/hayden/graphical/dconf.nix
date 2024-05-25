{ hostType, ... }:
if hostType == "nixos" then {
  dconf.settings = {
    "org/gnome/desktop/background" = {
      "picture-uri" = "/home/hayden/.background-img";
      "picture-uri-dark" = "/home/hayden/.background-img";
      "primary-color" = "#000000000000";
      "secondary-color" = "#000000000000";
    };
    "org/gnome/desktop/screensaver" = {
      "picture-uri" = "/home/hayden/.background-img";
      "picture-uri-dark" = "/home/hayden/.background-img";
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
  };
}
else { }
