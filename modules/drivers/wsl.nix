{
  config,
  lib,
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

    # WSL manages resolv.conf itself.
    myConfig.system.secureDns.enable = lib.mkDefault false;

    boot.loader = {
      systemd-boot.enable = lib.mkForce false;
      efi.canTouchEfiVariables = lib.mkForce false;
    };

    networking = {
      nftables.enable = lib.mkForce false;
      firewall.enable = lib.mkForce false;
      networkmanager.enable = lib.mkForce false;
    };

    services = {
      resolved.enable = lib.mkForce false;
      timesyncd.enable = lib.mkForce false;
    };
  };
}
