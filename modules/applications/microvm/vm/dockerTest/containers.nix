{ pkgs }:
let
  indexHtml = pkgs.writeText "index.html" "microvm-net is up";
in
{
  caddy = {
    autoStart = true;
    # readOnly = true;
    image = "caddy:alpine";
    ports = [ "80:80" ];
    volumes = [
      "${indexHtml}:/usr/share/caddy/index.html:ro"
      # "caddy_data:/data"
      # "caddy_config:/config"
    ];
    capabilities = {
      NET_BIND_SERVICE = true;
      # CAP_DAC_OVERRIDE = true;
      # CAP_NET_RAW = true;
      ALL = false;
    };
  };
}
