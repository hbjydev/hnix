{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [ cloudflared ];

  boot.kernel.sysctl."net.core.rmem_max" = 2500000;

  services.cloudflared = {
    enable = true;
    tunnels.hy-8hh-nixnuc = {
      warp-routing.enabled = false;
      credentialsFile = "/etc/cloudflared/hy-8hh-nixnuc.json";
      default = "http_status:404";
      ingress = {
        "*.hayden.moe" = "http://localhost:80";
      };
    };
  };

  systemd.services."cloudflared-tunnel-hy-8hh-nixnuc" = {
    environment.TUNNEL_METRICS = "localhost:8927";
  };
}
