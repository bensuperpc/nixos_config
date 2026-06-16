{
  enabled = true;
  role = "wsl";
  system = "x86_64-linux";
  ip = "127.0.0.1";
  port = 22;

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = ["apps/dev-base" "apps/dev-cpp" "apps/docker" ];
  platformProfiles = [ ];
}
