{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.kvm;

  vhostPackages = with pkgs; [
    virtiofsd
  ];

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      host = {
        description = "Install KVM and host virtualization tools";
        packages = with pkgs; [
          dnsmasq
          virt-manager
          virt-viewer
          qemu
          spice
          spice-gtk
        ];
      };
    };
  };
  anyEnabled = generated.anyEnabled || cfg.enableGuestServices;
in
{
  options.myConfig.apps.kvm = generated.options // {
    enableGuestServices = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate services for KVM guests";
    };
  };

  config = lib.mkMerge [
    generated.config
    (lib.mkIf anyEnabled {
      # virtualisation.spiceUSBRedirection.enable = true;
      virtualisation.libvirtd = {
        enable = true;
        allowedBridges = [ "virbr0" ];
        # qemu.swtpm.enable = true;
        qemu.package = pkgs.qemu_kvm;
        qemu.vhostUserPackages = vhostPackages;
      };

      systemd.services.libvirtd.serviceConfig = {
        StateDirectory = "libvirt";
        RuntimeDirectory = "libvirt";
        LoadCredentialEncrypted = lib.mkForce [ "" ];
      };

      # For guest only
      services.qemuGuest.enable = cfg.enableGuestServices;
      services.spice-vdagentd.enable = cfg.enableGuestServices;
    })
  ];
}
