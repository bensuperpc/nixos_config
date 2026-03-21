{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.tools;

  basePackages = with pkgs; [
    wget
    curl
    btop
    tree
    parallel
    cryptsetup
    coreutils-full
  ];

  systemPackages = with pkgs; [
    htop
    bottom
    lm_sensors
    fastfetch
    fio
    kernel-hardening-checker
  ];

  networkPackages = with pkgs; [
    croc
    parsync
  ];

  cliPackages = with pkgs; [
    tmux
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
    restic
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
    system = moduleHelpers.mkEnabledOption "Install system monitoring and info tools";
    network = moduleHelpers.mkEnabledOption "Install network and file transfer utilities";
    cli = moduleHelpers.mkEnabledOption "Install CLI tools and utilities";
    security = moduleHelpers.mkEnabledOption "Install security and encryption tools";
    archive = moduleHelpers.mkEnabledOption "Install backup and archive tools";
  };

  config = lib.mkMerge [ 
    {
      programs.dconf.enable = true;
      # btop to add CPU/GPU monitoring
      # Also need: boot.kernelModules = [ "kvm-intel" "coretemp" "msr" "intel_rapl_msr" "intel_rapl_common" ]; # k10temp for AMD
      # security.wrappers.btop = {
      #   owner = "root";
      #   group = "root";
      #   capabilities = "cap_perfmon,cap_sys_rawio,cap_sys_admin+ep";
      #   source = "${pkgs.btop}/bin/btop";
      # };

      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
    (lib.mkIf cfg.system {
    })
  ];
}

