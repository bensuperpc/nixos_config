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
  imports = [
    ../../common/home
  ];

  home = {
    username = "${userVars.user}";
    homeDirectory = "/home/${userVars.user}";

    packages = with pkgs; [
    ] ++ lib.optionals osConfig.myConfig.apps.development.cppTools.caching [
      pkgs.ccache
    ];

    sessionVariables = {
      CCACHE_DIR = "$HOME/.cache/ccache";
    };

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
    setupCcache = config.lib.dag.entryAfter ["writeBoundary"] ''
      mkdir -p $HOME/.cache/ccache
    '';

    # Generate SSH key if it doesn't exist
    generateSshKey = config.lib.dag.entryAfter ["writeBoundary"] ''
      if [ ! -f "$HOME/.ssh/${userVars.mainSshKeyName}" ]; then
        install -d -m 700 "$HOME/.ssh"
        ${pkgs.openssh}/bin/ssh-keygen -t ed25519 -a 256 -f "$HOME/.ssh/${userVars.mainSshKeyName}" -N "" -C "${userVars.email}"
      fi
    '';
  };
}