

{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.kvm;

  basePackages = with pkgs; [ ];

  kvmPackages = with pkgs; [
    dnsmasq
    virt-manager
    virt-viewer
    qemu
    spice
    spice-gtk
  ];

  vhostPackages = with pkgs; [
    virtiofsd
    qemu_kvm
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.host kvmPackages;

  anyEnabled = lib.any (x: x) [
    cfg.host
    cfg.enableGuestServices
  ];
in
{
  options.myConfig.apps.kvm = {
    host = moduleHelpers.mkEnabledOption "Install KVM and host virtualization tools";

    enableGuestServices = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate services for KVM guests";
    };
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
      # virtualisation.spiceUSBRedirection.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        allowedBridges = [ "virbr0" ];
      # qemu.wtpm.enable = true;
        qemu.vhostUserPackages = vhostPackages;
      };

      # For guest only
      services.qemuGuest.enable = cfg.enableGuestServices;
      services.spice-vdagentd.enable = cfg.enableGuestServices;
    })
  ];
}
