{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.utilities.kvm;

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
in
{
  options.myConfig.apps.utilities.kvm = generated.options // {
    guest = moduleHelpers.mkDisabledOption "Activate services for KVM guests";
  };

  config = lib.mkMerge [
    generated.config
    (lib.mkIf generated.anyEnabled {
      virtualisation.libvirtd = {
        enable = true;
        allowedBridges = [ "virbr0" ];
        qemu.package = pkgs.qemu_kvm;
        qemu.vhostUserPackages = vhostPackages;
      };

      systemd.services.libvirtd.serviceConfig = {
        StateDirectory = "libvirt";
        RuntimeDirectory = "libvirt";
        LoadCredentialEncrypted = lib.mkForce [ "" ];
      };
    })

    (lib.mkIf cfg.guest {
      services.qemuGuest.enable = true;
      services.spice-vdagentd.enable = true;
    })
  ];
}
