{
  config,
  lib,
  pkgs,
  ...
}:
let
  userVars = import ./variables.nix;
  passwordSecret = "${userVars.user}/password";
in
{
  users.groups.${userVars.user} = { };

  sops.secrets.${passwordSecret}.neededForUsers = true;

  users.users.${userVars.user} = {
    isNormalUser = true;
    description = userVars.fullName;
    group = userVars.user;
    extraGroups =
      userVars.extraGroups
      ++ lib.optional config.virtualisation.docker.enable "docker"
      ++ lib.optional config.virtualisation.libvirtd.enable "libvirtd";
    openssh.authorizedKeys.keys = userVars.sshPubKeyAccess;
    hashedPasswordFile = config.sops.secrets.${passwordSecret}.path;
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
