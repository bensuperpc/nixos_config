{
  config,
  osConfig,
  lib,
  pkgs,
  userVars,
  ...
}:

{
  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ServerAliveInterval = 60;
        IdentityFile = "~/.ssh/${userVars.defaultOnlineSSHKeyName}";
      };
      "github.com" = {
        HostName = "github.com";
        User = "${userVars.user}";
        Port = 22;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.githubSSHKeyName}";
      };
      "gitlab.com" = {
        HostName = "gitlab.com";
        User = "${userVars.user}";
        Port = 22;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.gitlabSSHKeyName}";
      };
      "codeberg.org" = {
        HostName = "codeberg.org";
        User = "${userVars.user}";
        Port = 22;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.codebergSSHKeyName}";
      };
      "code.forgejo.org" = {
        HostName = "code.forgejo.org";
        User = "${userVars.user}";
        Port = 22;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.forgejoSSHKeyName}";
      };
      "192.168.1.79" = {
        HostName = "192.168.1.79";
        User = "${userVars.user}";
        Port = 4444;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.localSSHKeyName}";
      };
    };
  };
}
