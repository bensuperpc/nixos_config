{
  config,
  osConfig,
  lib,
  moduleHelpers,
  userVars,
  ...
}:

let
  cfg = config.myConfig.apps.git;
in
{
  options.myConfig.apps.git.enable =
    moduleHelpers.mkBoolOption osConfig.myConfig.apps.development.dev.base "Git identity and SSH signing (follows the system `apps.development.dev.base` toggle by default)";

  config.programs.git = lib.mkIf cfg.enable {
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
