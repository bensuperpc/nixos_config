# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, osConfig, lib, pkgs, ... }:

let
  userVars = osConfig.myConfig.vars.users.bensuperpc;

  chromiumExtensions = [
    "ddkjiahejlhfcafbddmgiahcphecmpfh" # uBlock Origin Lite
    "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    "neebplgakaahbhdphmkckjjcegoiijjo" # Keepa (amazon price tracker)
    "cimiefiiaegbelhefglklhhakcgmhkai" # Plasma integration
    "fpnmgdkabkmnadcjpehmlllkndpkmiak" # Wayback Machine
    "kdbmhfkmnlmbkgbabkdealhhbfhlmmon" # SteamDB
    # "lclgfmnljgacfdpmmmjmfpdelndbbfhk" # SealSkin Isolation
  ];
  vscodeExtensions = with pkgs.vscode-extensions; [
    ms-vscode.cpptools
    ms-vscode.cpptools-extension-pack
    ms-vscode-remote.remote-containers
    ms-vscode.makefile-tools
    ms-python.python
    ms-azuretools.vscode-docker
    yzhang.markdown-all-in-one
    redhat.vscode-yaml
    jnoortheen.nix-ide
  ];
in
{
  imports = [
    ../common/home
  ];

  home = {
    username = "${userVars.user}";
    homeDirectory = "/home/${userVars.user}";
    packages = with pkgs; [
    ] ++ lib.optionals osConfig.myConfig.apps.development.ctools.caching [
      pkgs.ccache
    ];

    sessionVariables = {
      CCACHE_DIR = "$HOME/.cache/ccache";
    };

    activation.setupCcache = ''
      mkdir -p $HOME/.cache/ccache
    '';
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
    if [ ! -f "$HOME/.ssh/${userVars.mainSshKeyName}" ]; then
      install -d -m 700 "$HOME/.ssh"
      ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -a 256 -f "$HOME/.ssh/${userVars.mainSshKeyName}" -N "" -C "${userVars.email}"
    fi
  '';
  
  programs.git = lib.mkIf osConfig.myConfig.apps.development.dev.tooling {
    enable = true;
    settings = {
      user = {
        name = "${userVars.fullName}";
        email = "${userVars.email}";
      };
      init.defaultBranch = "main";
    };
  };

  programs.vscode = lib.mkIf osConfig.myConfig.apps.development.ide.enable {
    enable = true;
    profiles.default.extensions = vscodeExtensions;
  };

  programs.firefox = lib.mkIf osConfig.myConfig.apps.browser.core {
    enable = true;
    configPath = "${config.xdg.configHome}/mozilla/firefox";
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

  programs.chromium = lib.mkIf osConfig.myConfig.apps.browser.core{
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
        identityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };

      "github.com" = {
        hostname = "github.com";
        user = "${userVars.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };
      "gitlab.com" = {
        hostname = "gitlab.com";
        user = "${userVars.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };
      "codeberg.org" = {
        hostname = "codeberg.org";
        user = "${userVars.user}";
        port = 22;
        compression = true;
        identityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };
    };
  };
}