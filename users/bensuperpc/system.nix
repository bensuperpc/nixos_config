{
  config,
  lib,
  pkgs,
  userVars,
  ...
}:
let
  secretsEnabled = config.myConfig.system.secrets.enable;
in
{
  users.groups.${userVars.user} = { };

  sops.secrets = lib.mkIf secretsEnabled {
    "bensuperpc/password".neededForUsers = true;
  };

  users.users.${userVars.user} = lib.mkMerge [
    {
      isNormalUser = true;
      description = userVars.fullName;
      group = userVars.user;
      inherit (userVars) extraGroups;
      openssh.authorizedKeys.keys = userVars.sshPubKeyAccess;
      shell = pkgs.zsh;
    }
    (lib.mkIf secretsEnabled {
      hashedPasswordFile = config.sops.secrets."bensuperpc/password".path;
    })
    # Bootstrap only
    (lib.mkIf (!secretsEnabled) {
      initialPassword = "password";
    })
  ];

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
