{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.tools;

  systemPackages = with pkgs; [
    htop
    bottom
    lm_sensors
    kernel-hardening-checker
  ];

  networkPackages = with pkgs; [
    parsync
  ];

  cliPackages = with pkgs; [
    ripgrep
    ripgrep-all
    pwgen
    fd
    jq
    dos2unix
    fdupes
    flex
    fmt
    help2man
    onboard
    jp2a
    llmfit
    colorls
    eza
  ];

  securityPackages = with pkgs; [
    bitwarden-desktop
    bitwarden-cli
  ];

  archivePackages = with pkgs; [
    internetarchive
    kiwix
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.system systemPackages
    ++ lib.optionals cfg.network networkPackages
    ++ lib.optionals cfg.cli cliPackages
    ++ lib.optionals cfg.security securityPackages
    ++ lib.optionals cfg.archive archivePackages;

    anyEnabled = lib.any (x: x) [
      cfg.system
      cfg.network
      cfg.cli
      cfg.security
      cfg.archive
    ];
in
{
  options.myConfig.apps.tools = {
    system = moduleHelpers.mkDisabledOption "Install system monitoring and info tools";
    network = moduleHelpers.mkDisabledOption "Install network and file transfer utilities";
    cli = moduleHelpers.mkDisabledOption "Install CLI tools and utilities";
    security = moduleHelpers.mkDisabledOption "Install security and encryption tools";
    archive = moduleHelpers.mkDisabledOption "Install backup and archive tools";
  };

  config = lib.mkMerge [ 
    {
      # btop to add CPU/GPU monitoring
      # Also need: boot.kernelModules = [ "kvm-intel" "coretemp" "msr" "intel_rapl_msr" "intel_rapl_common" ]; # k10temp for AMD
      # security.wrappers.btop = {
      #   owner = "root";
      #   group = "root";
      #   capabilities = "cap_perfmon,cap_sys_rawio,cap_sys_admin+ep";
      #   source = "${pkgs.btop}/bin/btop";
      # };
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
    (lib.mkIf cfg.system {
    })
  ];
}

