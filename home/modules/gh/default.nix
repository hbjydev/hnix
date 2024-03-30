{ pkgs, ... }:
{
  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    settings = {
      version = 1;
      aliases = {
        clone = "repo clone";
        co = "pr checkout";
        v = "repo view --web";
        pv = "pr view --web";
        pr = "pr create --web";
      };
      editor = "nvim";
      git_protocol = "https";
    };
  };

  home.packages = [ pkgs.gh-dash ];
  xdg.configFile."gh-dash/config.yml".source = ./gh-dash.yaml;
}
