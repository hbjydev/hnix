{ ... }:
let
  oxocarbon = (import ../theme.nix).oxocarbon.dark;
in
{
  programs.k9s = {
    enable = true;
    settings = {
      k9s = {
        logoless = true;
      };
    };

    skins.skin = {
      k9s = {
        body = {
          fgColor   = oxocarbon.base04;
          bgColor   = oxocarbon.base00;
          logoColor = oxocarbon.base0A;
        };

        prompt = {
          fgColor      = oxocarbon.base04;
          bgColor      = oxocarbon.base00;
          suggestColor = oxocarbon.base03;

          border = {
            default = oxocarbon.base0A;
            command = oxocarbon.base0A;
          };
        };

        info = {
          fgColor        = oxocarbon.base04;
          selectionColor = oxocarbon.base04;
        };

        frame = {
          border = {
            fgColor    = oxocarbon.base02;
            focusColor = oxocarbon.base0C;
          };

          menu = {
            fgColor     = oxocarbon.base04;
            keyColor    = oxocarbon.base0A;
            numKeyColor = oxocarbon.base0A;
          };

          crumbs = {
            fgColor     = oxocarbon.base04;
            bgColor     = oxocarbon.base00;
            activeColor = oxocarbon.base01;
          };

          status = {
            newColor       = oxocarbon.base0E;
            modifyColor    = oxocarbon.base0B;
            addColor       = oxocarbon.base0B;
            errorColor     = oxocarbon.base0A;
            highlightcolor = oxocarbon.base0A;
            killColor      = oxocarbon.base0A;
            completedColor = oxocarbon.base03;
          };

          title = {
            fgColor        = oxocarbon.base04;
            bgColor        = oxocarbon.base00;
            highlightColor = oxocarbon.base0C;
            counterColor   = oxocarbon.base04;
            filterColor    = oxocarbon.base04;
          };
        };

        views = {
          table = {
            fgColor       = oxocarbon.base04;
            bgColor       = oxocarbon.base00;
            cursorBgColor = oxocarbon.base01;
            cursorFgColor = oxocarbon.base00;
            markColor     = oxocarbon.base0C;

            header = {
              fgColor = oxocarbon.base03;
              bgColor = oxocarbon.base00;
            };
          };

          yaml = {
            keyColor = oxocarbon.base0A;
            colonColor = oxocarbon.base03;
            valueColor = oxocarbon.base04;
          };

          logs = {
            fgColor = oxocarbon.base04;
            bgColor = oxocarbon.base00;

            indicator = {
              fgColor = oxocarbon.base03;
              bgColor = oxocarbon.base00;
            };
          };
        };
      };
    };
  };
}
