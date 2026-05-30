# tests/check-virtualization.nix
{ config, pkgs, lib, ... }:

let
  requiredPkgs = with pkgs; [
    virt-manager
    virt-viewer
    qemu
  ];
in
{
  assertions =
    [
      {
        assertion = config.myConfig.apps.kvm.host;
        message = "KVM host virtualization must be enabled";
      }
      {
        assertion = config.virtualisation.libvirtd.enable;
        message = "Libvirtd service must be enabled";
      }
    ]
    ++ map (pkg: {
      assertion = lib.elem pkg config.environment.systemPackages;
      message = "Package missing: ${pkg.name}";
    }) requiredPkgs;
}
