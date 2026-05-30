{ config, osConfig, lib, pkgs, userVars, ... }:

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
  imports = [
    ../../common/home
  ];

  home = {
    username = "${userVars.user}";
    homeDirectory = "/home/${userVars.user}";

    packages = with pkgs; [
    ];

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
    generateSshKey = lib.hm.dag.entryAfter ["installPackages"] (
      lib.concatMapStringsSep "\n" (keyName: ''
        if [ ! -f "$HOME/.ssh/${keyName}" ]; then
          install -d -m 700 "$HOME/.ssh"
          ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -a 256 -f "$HOME/.ssh/${keyName}" -N "" -C "${userVars.email}"
          chmod 600 "$HOME/.ssh/${keyName}"
          chmod 644 "$HOME/.ssh/${keyName}.pub"
        fi
      '') sshKeys
    );

    cloneNixosConfig = lib.hm.dag.entryAfter [ "installPackages" ] ''
      TARGET_DIR="$HOME/Repository/nixos_config"
      if [ ! -d "$TARGET_DIR" ]; then
        echo "Cloning the NixOS configuration repository into $TARGET_DIR..."
        mkdir -p "$(dirname "$TARGET_DIR")"
        ${pkgs.git}/bin/git clone https://github.com/bensuperpc/nixos_config.git "$TARGET_DIR"
      else
        echo "The repository already exists in $TARGET_DIR, skipping this step."
      fi
    '';
  };
}