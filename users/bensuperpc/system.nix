{ config, lib, pkgs, ... }:

let
  userVars = config.myConfig.vars.users.bensuperpc;
in
{
  imports = [ ../common/system ];

  users.groups.${userVars.user} = {
    members = [];
  };

  users.users.${userVars.user} = {
    isNormalUser = true;
    description = userVars.fullName;
    initialPassword = userVars.initialPassword;
    group = userVars.user;
    extraGroups = userVars.extraGroups;
    openssh.authorizedKeys.keys = userVars.sshPubKeyAccess;
    shell = pkgs.${userVars.shell};
  };

  security.sudo.extraRules = [
    {
      users = [ userVars.user ];
      commands = [
        # Allow running any command without password (TODO: Remove later)
        { command = "ALL"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/poweroff"; options = [ "NOPASSWD" ]; }
        { command = "${pkgs.systemd}/bin/reboot";   options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  home-manager.users.${userVars.user} = {
    imports = [ ./home.nix ];
    home.stateVersion = userVars.homeStateVersion;
  };
}