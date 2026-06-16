{ config, lib, pkgs, ... }:

let
  kernelMap = {
    latest   = pkgs.linuxPackages_latest;
    zen      = pkgs.linuxPackages_zen;
    hardened = pkgs.linuxPackages_latest_hardened;
    libre    = pkgs.linuxPackages_latest-libre;
    lts      = pkgs.linuxPackages;
  };
in
{
  options.myConfig.boot.kernel = lib.mkOption {
    type    = lib.types.enum (builtins.attrNames kernelMap);
    default = "latest";
    description = "Kernel variant to use (latest, zen, hardened, libre, lts).";
  };

  config = {
    boot.kernelPackages = lib.mkOverride 50 kernelMap.${config.myConfig.boot.kernel};
    security = {
      # Needed for KDE/GNOME GUI.
      polkit.enable = true;

      # Protect the kernel image from accidental deletion or modification
      protectKernelImage = true;

      # Can break iptables, WireGuard, and libvirt.
      lockKernelModules = false;

      # Enable user namespaces for better security in containerized environments (e.g. Docker, Podman, etc.)
      allowUserNamespaces = true;
    };
  };
}
