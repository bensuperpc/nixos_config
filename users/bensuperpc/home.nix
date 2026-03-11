# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, vars, ... }:

{
  imports = [
    ../common
  ];

  programs.home-manager.enable = true;

  home = {
    username = "${vars.admin.user}";
    homeDirectory = "/home/${vars.admin.user}";
    packages = with pkgs; [
    ];
  };

  # Reset on each update
  # home.activation.resetPlasma = config.lib.dag.entryBefore ["checkLinkTargets"] ''
  #   shopt -s nullglob

  #   for path in \
  #     "$HOME/.config/plasma"* \
  #     "$HOME/.config/kde"* \
  #     "$HOME/.config/kwin"* \
  #     "$HOME/.config/kscreen"* \
  #     "$HOME/.config/kdeglobals" \
  #     "$HOME/.local/share/plasma" \
  #     "$HOME/.local/share/kactivitymanagerd" \
  #     "$HOME/.local/share/kscreen" \
  #     "$HOME/.cache/plasma"* \
  #     "$HOME/.cache/kscreen"*; do

  #     rm -rf "$path"
  #   done
  # '';

  home.activation.generateSshKey = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.ssh/id_ed25519" ]; then
      install -d -m 700 "$HOME/.ssh"
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -a 256 -f "$HOME/.ssh/id_ed25519" -N "" -C "${vars.admin.email}"
    fi
  '';

  home.sessionVariables = {
  };

  home.file = {
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
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "${vars.admin.fullName}";
        email = "${vars.admin.email}";
      };
      init.defaultBranch = "main";
    };
  };

  # environment.shellAliases = {
  # };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
      };

      "github.com" = {
        hostname = "github.com";
        user = "${vars.admin.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/id_ed25519";
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "${vars.admin.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/id_ed25519";
      };
      "codeberg.org" = {
        hostname = "codeberg.org";
        user = "${vars.admin.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  home.stateVersion = "25.11";
}