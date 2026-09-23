{
  pkgs,
  ...
}:
{
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.zsh;
    defaultUserHome = "/home";
  };
}
