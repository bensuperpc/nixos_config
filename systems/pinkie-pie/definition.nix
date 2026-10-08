{
  enabled = false;
  role = "desktop";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  profiles = [
    "platform/gpu-intel-skylake"
    "apps/dev-all"
    "apps/games"
    "apps/docker"
    "apps/browser"
    "apps/communication"
    "apps/torrent"
    "apps/files"
  ];
}
