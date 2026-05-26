# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, osConfig, lib, pkgs, userVars, ... }:

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
  programs.tmux = { 
    enable = true;
    plugins = with pkgs; [
      tmuxPlugins.sensible
    ];
    extraConfig = builtins.readFile ./asset/tmux.cfg;
  };

  programs.git = lib.mkIf osConfig.myConfig.apps.development.dev.tooling {
    enable = true;
    lfs.enable = true;
    settings = {
      user = {
        name = "${userVars.fullName}";
        email = "${userVars.email}";
      };
      maintenance = {
        auto = true;
        strategy = "incremental";
      };
      init = {
        defaultBranch = "main";
      };
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

  programs.chromium = lib.mkIf osConfig.myConfig.apps.browser.core {
    enable = true;
    extensions = chromiumExtensions;
  };

  # environment.shellAliases = {
  # };

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;

    settings = {
      "*" = {
        ServerAliveInterval = 60;
        IdentityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };

      "github.com" = {
        HostName = "github.com";
        User = "${userVars.user}";
        Port = 22;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };
      "gitlab.com" = {
        HostName = "gitlab.com";
        User = "${userVars.user}";
        Port = 22;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };
      "codeberg.org" = {
        HostName = "codeberg.org";
        User = "${userVars.user}";
        Port = 22;
        Compression = true;
        IdentityFile = "~/.ssh/${userVars.mainSshKeyName}";
      };
    };
  };
}