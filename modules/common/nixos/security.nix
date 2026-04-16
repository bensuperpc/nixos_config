{ ... }:
{
  security = {
    # Needed for KDE/GNOME GUI.
    # polkit.enable = true;

    # Protect the kernel image from accidental deletion or modification
    protectKernelImage = true;

    # Can break iptables, WireGuard, and libvirt.
    lockKernelModules = false;

    # Enable user namespaces for better security in containerized environments (e.g. Docker, Podman, etc.)
    allowUserNamespaces = true;
  };
}