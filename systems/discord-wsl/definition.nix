{
  enabled = true;
  role = "wsl";
  system = "x86_64-linux";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [
    "apps/dev-base"
    "apps/dev-cpp"
    "apps/docker"
  ];
  platformProfiles = [ ];
}
