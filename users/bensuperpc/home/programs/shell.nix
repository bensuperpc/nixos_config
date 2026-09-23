# Personal CLI tools; the shared zsh/starship/direnv setup lives in users/common/home/shell.nix.
{
  config,
  lib,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.cliTools;
in
{
  options.myConfig.apps.cliTools.enable =
    moduleHelpers.mkEnabledOption "Shell helpers (fzf, zoxide, eza, bat)";

  config.programs = lib.mkIf cfg.enable {
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
      icons = "auto";
      git = true;
    };

    bat = {
      enable = true;
    };
  };
}
