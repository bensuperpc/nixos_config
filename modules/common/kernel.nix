{
  config,
  lib,
  pkgs,
  ...
}:

let
  kernelMap = {
    latest = pkgs.linuxPackages_latest;
    zen = pkgs.linuxPackages_zen;
    lts = pkgs.linuxPackages;
  };
in
{
  options.myConfig.system.kernel = lib.mkOption {
    type = lib.types.enum (builtins.attrNames kernelMap);
    default = "latest";
    description = "Kernel variant to use (latest, zen, lts).";
  };

  config = {
    boot.kernelPackages = kernelMap.${config.myConfig.system.kernel};
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
