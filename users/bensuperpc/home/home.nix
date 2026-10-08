{
  lib,
  pkgs,
  userVars,
  ...
}:

let
  sshKeys = lib.unique [
    userVars.localSSHKeyName
    userVars.githubSSHKeyName
    userVars.gitlabSSHKeyName
    userVars.codebergSSHKeyName
    userVars.forgejoSSHKeyName
    userVars.defaultOnlineSSHKeyName
  ];
in
{
  home = {
    file = {
      "test_home.txt" = {
        source = ./asset/test_home.txt;
        target = ".test_home.txt";
        force = true;
        recursive = true;
      };

      "Repository/work/.keep".text = "";
      "Repository/personal/.keep".text = "";
      "Repository/opensource/.keep".text = "";
    };
  };

  home.activation = {
    generateSshKey = lib.hm.dag.entryAfter [ "installPackages" ] (
      lib.concatMapStringsSep "\n" (keyName: ''
        if [ ! -f "$HOME/.ssh/${keyName}" ]; then
          install -d -m 700 "$HOME/.ssh"
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -a 256 -f "$HOME/.ssh/${keyName}" -N "" -C "${userVars.email}"
          chmod 600 "$HOME/.ssh/${keyName}"
          chmod 644 "$HOME/.ssh/${keyName}.pub"
        fi
      '') sshKeys
    );
  };
}
