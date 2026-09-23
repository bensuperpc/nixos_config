{
  config,
  lib,
  moduleHelpers,
  userVars,
  ...
}:

let
  cfg = config.myConfig.apps.ssh;
  hosts = {
    "github.com".key = userVars.githubSSHKeyName;
    "gitlab.com".key = userVars.gitlabSSHKeyName;
    "codeberg.org".key = userVars.codebergSSHKeyName;
    "code.forgejo.org".key = userVars.forgejoSSHKeyName;
    "192.168.1.79" = {
      key = userVars.localSSHKeyName;
      port = 4444;
    };
  };

  mkHost =
    host:
    {
      key,
      port ? 22,
    }:
    {
      HostName = host;
      User = userVars.user;
      Port = port;
      Compression = true;
      IdentityFile = "~/.ssh/${key}";
    };
in
{
  options.myConfig.apps.ssh.enable =
    moduleHelpers.mkEnabledOption "SSH client configuration (one key per forge)";

  config.programs.ssh = lib.mkIf cfg.enable {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ServerAliveInterval = 60;
        IdentityFile = "~/.ssh/${userVars.defaultOnlineSSHKeyName}";
      };
    }
    // lib.mapAttrs mkHost hosts;
  };
}
