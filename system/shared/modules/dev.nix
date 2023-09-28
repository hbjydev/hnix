{ ... }:
{
  programs.go = {
    enable = true;
    goPath = "Development/language/go";
  };

  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        logoless = true;
      };
    };
    skin = (builtins.readFile ../../../config/k9s/skin.yml);
  };
}
