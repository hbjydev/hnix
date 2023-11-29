isDarwin:

{
  git = {
    s = "status -s";
    a = "add";

    ci = "commit";
    cm = "commit -m";

    ch = "checkout";

    b = "branch";

    p = "pull";
    pp = "push";

    l = "log --pretty=oneline --abbrev-commit";

    d = "diff";
    ds = "diff --staged";

    wt = "worktree";
  };

  zsh = {
    s = ''doppler run --config "nix" --project "$(whoami)"'';

    cat = "bat --paging=never";

    vi = "nvim";
    vim = "nvim";

    rebuild = (
      if isDarwin
      then "darwin-rebuild switch --flake \"$HOME/.config/nix#work-darwin\""
      else "sudo nixos-rebuild switch --flake '/etc/nixos#personal-nixos'"
    );

    dc = "docker compose";
    dcu = "docker compose up";
    dcd = "docker compose down";
    dcl = "docker compose logs";
    dclf = "docker compose logs -f";
    dcc = "docker compose cp";
    dci = "docker compose inspect";
    dce = "docker compose exec";
    dcr = "docker compose restart";

    g = "git";

    k = "kubectl";
    kw = "kubectl -o wide";
    ky = "kubectl -o yaml";
    kj = "kubectl -o json";

    tf = "terraform";

    ssh = "TERM=xterm-256color ssh";

    nb = "nix build --json --no-link --print-build-logs";

    watch = "viddy";
  };
}
