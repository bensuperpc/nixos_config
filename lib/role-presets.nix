{
  minimal = {
    platformProfiles = [ "platform/base" ];
    appProfiles = [ ];
    hwProfiles = [ ];
    policyProfiles = [ ];
  };

  server = {
    platformProfiles = [ "platform/base" "platform/no-gpu" ];
    appProfiles = [ "apps/docker" ];
    hwProfiles = [ ];
    policyProfiles = [ ];
  };

  desktop = {
    platformProfiles = [ "platform/base" "platform/kde-plasma" ];
    appProfiles = [ "apps/custom" "apps/desktop-runtime" "apps/desktop" "apps/multimedia" "apps/utilities" "apps/office" ];
    hwProfiles = [ ];
    policyProfiles = [ "policy/kernel-zen" ];
  };

  workstation = {
    platformProfiles = [ "platform/base" "platform/kde-plasma" ];
    appProfiles = [ "apps/custom" "apps/desktop-runtime" "apps/desktop" "apps/development" "apps/multimedia" "apps/utilities" "apps/office" ];
    hwProfiles = [ ];
    policyProfiles = [ "policy/kernel-zen" ];
  };

  family = {
    platformProfiles = [ "platform/base" "platform/kde-plasma" ];
    appProfiles = [ "apps/desktop" "apps/communication" "apps/multimedia" "apps/office" "apps/files" "apps/utilities" ];
    hwProfiles = [ ];
    policyProfiles = [ "policy/kernel-zen" ];
  };
}