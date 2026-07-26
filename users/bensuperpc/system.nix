{
  config,
  lib,
  pkgs,
  userVars,
  ...
}:
{
  users.groups.${userVars.user} = {
    members = [ ];
  };

  users.users.${userVars.user} = {
    isNormalUser = true;
    description = userVars.fullName;
    initialPassword = "password";
    group = userVars.user;
    inherit (userVars) extraGroups;
    openssh.authorizedKeys.keys = userVars.sshPubKeyAccess;
    shell = pkgs.zsh;
  };

  security.sudo.extraRules = [
    {
      users = [ userVars.user ];
      commands = [
        # Allow running any command without password (TODO: Remove later)
        {
          command = "ALL";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/poweroff";
          options = [ "NOPASSWD" ];
        }
        {
          command = "${pkgs.systemd}/bin/reboot";
          options = [ "NOPASSWD" ];
        }
      ];
    }
  ];

  home-manager.users.${userVars.user} = {
    imports = [ ./home ];
    _module.args.userVars = userVars;
    home.stateVersion = "26.05"; # config.system.stateVersion;
  };
}
