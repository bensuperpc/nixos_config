{
  osConfig,
  lib,
  userVars,
  ...
}:

{
  programs.git = lib.mkIf osConfig.myConfig.apps.development.dev.base {
    enable = true;
    # dysk.enable = true;
    settings = {
      user = {
        name = "${userVars.fullName}";
        email = "${userVars.email}";
        signingKey = "~/.ssh/${userVars.defaultOnlineSSHKeyName}.pub";
      };
      commit.gpgSign = true;
      tag.gpgSign = true;
      gpg.format = "ssh";
      maintenance = {
        auto = true;
        strategy = "incremental";
      };
      init = {
        defaultBranch = "main";
      };
    };
  };
}
