# Personal CLI tools; the shared zsh/starship/direnv setup lives in users/common/home/shell.nix.
_:

{
  programs = {
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
