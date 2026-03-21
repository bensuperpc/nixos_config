# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, osConfig, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  chromiumExtensions = [
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "neebplgakaahbhdphmkckjjcegoiijjo" # Keepa (amazon price tracker)
    "cimiefiiaegbelhefglklhhakcgmhkai" # Plasma integration
    "fpnmgdkabkmnadcjpehmlllkndpkmiak" # Wayback Machine
    "kdbmhfkmnlmbkgbabkdealhhbfhlmmon" # SteamDB
    # "lclgfmnljgacfdpmmmjmfpdelndbbfhk" # SealSkin Isolation
  ];
in
{
  imports = [
    ../common/home
  ];

  home = {
    username = "${vars.admin.user}";
    homeDirectory = "/home/${vars.admin.user}";
    packages = with pkgs; [
    ];
  };

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

  # Generate SSH key if it doesn't exist
  home.activation.generateSshKey = config.lib.dag.entryAfter ["writeBoundary"] ''
    if [ ! -f "$HOME/.ssh/${vars.admin.mainSshKeyName}" ]; then
      install -d -m 700 "$HOME/.ssh"
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -a 256 -f "$HOME/.ssh/${vars.admin.mainSshKeyName}" -N "" -C "${vars.admin.email}"
    fi
  '';
  
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

  programs.vscode = {
    enable = true;
    profiles.default.extensions = with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vscode.cpptools-extension-pack
      ms-vscode-remote.remote-containers
      ms-vscode.makefile-tools
      ms-python.python
      ms-vscode-remote.remote-containers
      ms-azuretools.vscode-docker
      yzhang.markdown-all-in-one
      redhat.vscode-yaml
    ];
  };

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
    };
  };

  programs.chromium = {
    enable = true;
    extensions = chromiumExtensions;
  };

  # environment.shellAliases = {
  # };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    matchBlocks = {
      "*" = {
        serverAliveInterval = 60;
        identityFile = "~/.ssh/${vars.admin.mainSshKeyName}";
      };

      "github.com" = {
        hostname = "github.com";
        user = "${vars.admin.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/${vars.admin.mainSshKeyName}";
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "${vars.admin.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/${vars.admin.mainSshKeyName}";
      };
      "codeberg.org" = {
        hostname = "codeberg.org";
        user = "${vars.admin.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/${vars.admin.mainSshKeyName}";
      };
    };
  };
}