{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.tools;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      system = {
        description = "Install system monitoring and info tools";
        packages = with pkgs; [ htop bottom lm_sensors kernel-hardening-checker ];
      };
      network = {
        description = "Install network and file transfer utilities";
        packages = with pkgs; [ parsync ];
      };
      cli = {
        description = "Install CLI tools and utilities";
        packages = with pkgs; [
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
      };
      security = {
        description = "Install security and encryption tools";
        packages = with pkgs; [
          # bitwarden-desktop
          # bitwarden-cli
          osslsigncode
        ];
      };
      archive = {
        description = "Install backup and archive tools";
        packages = with pkgs; [ internetarchive kiwix ];
      };
      crackingPassword = {
        description = "Install password cracking tools (for security auditing and recovery purposes only)";
        packages = with pkgs; [ cracklib hashcat ];
      };
    };
  };
in
{
  options.myConfig.apps.tools = generated.options;

  # btop to add CPU/GPU monitoring
  # Also need: boot.kernelModules = [ "kvm-intel" "coretemp" "msr" "intel_rapl_msr" "intel_rapl_common" ]; # k10temp for AMD
  # security.wrappers.btop = {
  #   owner = "root";
  #   group = "root";
  #   capabilities = "cap_perfmon,cap_sys_rawio,cap_sys_admin+ep";
  #   source = "${pkgs.btop}/bin/btop";
  # };
  config = generated.config;
}
