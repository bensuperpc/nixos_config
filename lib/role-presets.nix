{
  minimal = {
    platformProfiles = [ ];
    appProfiles = [ ];
    policyProfiles = [ ];
  };

  # First-install role: minimal + SSH, without sops-nix.
  bootstrap = {
    platformProfiles = [
      "platform/bootstrap"
    ];
    appProfiles = [ ];
    policyProfiles = [ ];
  };

  wsl = {
    platformProfiles = [
      "platform/gpu-software"
      "platform/no-gui"
      "platform/wsl"
    ];
    appProfiles = [ ];
    policyProfiles = [ ];
  };

  server = {
    platformProfiles = [
      "platform/no-gui"
    ];
    appProfiles = [ "apps/docker" ];
    policyProfiles = [ ];
  };

  desktop = {
    platformProfiles = [
      "platform/kde-plasma"
    ];
    appProfiles = [
      "apps/custom"
      "apps/desktop-runtime"
      "apps/desktop"
      "apps/multimedia"
      "apps/utilities"
      "apps/office"
    ];
    policyProfiles = [ "policy/kernel-latest" ];
  };

  workstation = {
    platformProfiles = [
      "platform/kde-plasma"
    ];
    appProfiles = [
      "apps/custom"
      "apps/desktop-runtime"
      "apps/desktop"
      "apps/dev-all"
      "apps/multimedia"
      "apps/utilities"
      "apps/office"
      "apps/virtualization"
      "apps/network-servers"
    ];
    policyProfiles = [ "policy/kernel-latest" ];
  };

  full = {
    platformProfiles = [
      "platform/kde-plasma"
    ];
    appProfiles = [
      "apps/custom"
      "apps/docker"
      "apps/games"
      "apps/desktop-runtime"
      "apps/desktop"
      "apps/browser"
      "apps/torrent"
      "apps/communication"
      "apps/dev-all"
      "apps/multimedia"
      "apps/files"
      "apps/utilities"
      "apps/office"
      "apps/virtualization"
      "apps/network-servers"
      "apps/ai"
    ];
    policyProfiles = [ "policy/kernel-latest" ];
  };

  family = {
    platformProfiles = [
      "platform/kde-plasma"
    ];
    appProfiles = [
      "apps/desktop-runtime"
      "apps/desktop"
      "apps/browser"
      "apps/communication"
      "apps/torrent"
      "apps/multimedia"
      "apps/office"
      "apps/files"
      "apps/utilities"
    ];
    policyProfiles = [ "policy/kernel-latest" ];
  };
}
