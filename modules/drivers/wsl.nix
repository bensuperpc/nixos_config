{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.drivers.wsl;
in
{
  options.myConfig.drivers.wsl = {
    enable = moduleHelpers.mkDisabledOption "Enable WSL stack and tools.";
  };

  config = lib.mkIf cfg.enable {
    wsl = {
      enable = true;
    };

    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
    };

    networking = {
      nameservers = lib.mkForce [ ];
      nftables.enable = lib.mkForce false;
      firewall.enable = lib.mkForce false;
      networkmanager.enable = lib.mkForce false;
    };

    services = {
      resolved.enable = lib.mkForce false;
      timesyncd.enable = lib.mkForce false;
    };

    # loginctl enable-linger $USER
    # then wsl --shutdown

    # systemd.user.services.dbus = {
    #   wantedBy = [ "default.target" ];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.dbus}/bin/dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation";
    #   };
    # };

    # systemd.user.services.dbus = {
    #   wantedBy = [ "default.target" ];
    #   wants = [ "dbus.socket" ];
    #   after = [ "dbus.socket" ];
    # };
    # systemd.user.sockets.dbus = {
    #   wantedBy = [ "sockets.target" ];
    # };
  };
}
