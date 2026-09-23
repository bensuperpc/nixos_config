{
  config,
  pkgs,
  userVars,
  ...
}:
{
  users.groups.${userVars.user} = { };

  sops.secrets."bensuperpc/password".neededForUsers = true;

  users.users.${userVars.user} = {
    isNormalUser = true;
    description = userVars.fullName;
    group = userVars.user;
    inherit (userVars) extraGroups;
    openssh.authorizedKeys.keys = userVars.sshPubKeyAccess;
    shell = pkgs.zsh;
    hashedPasswordFile = config.sops.secrets."bensuperpc/password".path;
  };

  security.sudo.extraRules = [
    {
      users = [ userVars.user ];
      commands = [
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
    imports = [
      ./home
      ./../common/home
    ];
    _module.args.userVars = userVars;
    home.stateVersion = config.system.stateVersion;
  };
}
