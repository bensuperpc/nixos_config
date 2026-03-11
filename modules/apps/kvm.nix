{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [ 
    dnsmasq
    virt-manager
    virt-viewer
    qemu
    spice
    spice-gtk
  ];

  security.polkit.enable = true;
  # virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    allowedBridges = [ "virbr0" ];
   # qemu.wtpm.enable = true;
    qemu.vhostUserPackages = with pkgs; [ 
      virtiofsd
      qemu_kvm
    ];
  };

  # For guest only
  # services.qemuGuest.enable = true;
  # services.spice-vdagentd.enable = true;
}