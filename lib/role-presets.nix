let
  kdePlasma = [ "platform/kde-plasma" ];
  latestKernel = [ "policy/kernel-latest" ];

  desktopApps = [
    "apps/desktop-runtime"
    "apps/desktop"
    "apps/multimedia"
    "apps/utilities"
    "apps/office"
  ];

  workstationApps = desktopApps ++ [
    "apps/dev-all"
    "apps/virtualization"
    "apps/network-servers"
  ];

  everydayApps = [
    "apps/browser"
    "apps/communication"
    "apps/torrent"
    "apps/files"
  ];

  familyApps = desktopApps ++ everydayApps;

  fullApps =
    workstationApps
    ++ everydayApps
    ++ [
      "apps/docker"
      "apps/games"
      "apps/ai"
    ];

  mkGraphicalRole = apps: kdePlasma ++ apps ++ latestKernel;
in
{
  minimal = [ ];

  server = [
    "platform/no-gui"
    "apps/docker"
  ];

  desktop = mkGraphicalRole desktopApps;
  workstation = mkGraphicalRole workstationApps;
  family = mkGraphicalRole familyApps;
  full = mkGraphicalRole fullApps;
}
