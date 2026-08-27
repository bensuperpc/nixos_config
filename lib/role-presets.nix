{
  minimal = {
    platformProfiles = [ "platform/base" ];
    appProfiles = [ ];
    policyProfiles = [ ];
  };

  wsl = {
    platformProfiles = [
      "platform/base"
      "platform/gpu-software"
      "platform/no-gui"
      "platform/wsl"
    ];
    appProfiles = [ ];
    policyProfiles = [ ];
  };

  server = {
    platformProfiles = [
      "platform/base"
      "platform/no-gui"
    ];
    appProfiles = [ "apps/docker" ];
    policyProfiles = [ ];
  };

  desktop = {
    platformProfiles = [
      "platform/base"
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
      "platform/base"
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
      "platform/base"
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
      "platform/base"
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
