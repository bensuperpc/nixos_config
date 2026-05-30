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
    # pwgen # Abandoned
    fd
    jq
    yq
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
    jhead
  ];

  securityPackages = with pkgs; [
    # bitwarden-desktop
    # bitwarden-cli
    osslsigncode
  ];

  archivePackages = with pkgs; [
    internetarchive
    kiwix
  ];

  crackingPasswordPackages = with pkgs; [
    cracklib
    hashcat
  ];


  enabledOptionalsPackages =
    lib.optionals cfg.system systemPackages
    ++ lib.optionals cfg.network networkPackages
    ++ lib.optionals cfg.cli cliPackages
    ++ lib.optionals cfg.security securityPackages
    ++ lib.optionals cfg.archive archivePackages
    ++ lib.optionals cfg.crackingPassword crackingPasswordPackages;

    anyEnabled = lib.any (x: x) [
      cfg.system
      cfg.network
      cfg.cli
      cfg.security
      cfg.archive
      cfg.crackingPassword
    ];
in
{
  options.myConfig.apps.tools = {
    system = moduleHelpers.mkDisabledOption "Install system monitoring and info tools";
    network = moduleHelpers.mkDisabledOption "Install network and file transfer utilities";
    cli = moduleHelpers.mkDisabledOption "Install CLI tools and utilities";
    security = moduleHelpers.mkDisabledOption "Install security and encryption tools";
    archive = moduleHelpers.mkDisabledOption "Install backup and archive tools";
    crackingPassword = moduleHelpers.mkDisabledOption "Install password cracking tools (for security auditing and recovery purposes only)";
  };

  config = lib.mkIf anyEnabled {
    environment.systemPackages = enabledOptionalsPackages;

    # btop to add CPU/GPU monitoring
    # Also need: boot.kernelModules = [ "kvm-intel" "coretemp" "msr" "intel_rapl_msr" "intel_rapl_common" ]; # k10temp for AMD
    # security.wrappers.btop = {
    #   owner = "root";
    #   group = "root";
    #   capabilities = "cap_perfmon,cap_sys_rawio,cap_sys_admin+ep";
    #   source = "${pkgs.btop}/bin/btop";
    # };
  };
}

