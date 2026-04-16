{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.qt6;


  qtPackages = with pkgs.qt6; [
    # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/qt-6/default.nix
    qtbase
    qtwebengine
    qttools
    qtdeclarative
    qt5compat
    qtwebchannel
    qtpositioning
    qtshadertools
    qtnetworkauth
    qtsvg
    qtmultimedia
    qtimageformats
    qtquick3d
    qt3d
    qtcharts
    qtgraphs
    qtscxml
    qtwayland
    qtspeech
    qtsensors
    qmake
    qtmqtt
    qtgrpc
    qtlottie
    qtserialbus
    qtserialport
    qtspeech
    qttranslations
  ];

  qtcreatorPackages = with pkgs; [
    qtcreator
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.base qtPackages
    ++ lib.optionals cfg.qtcreator qtcreatorPackages;


  anyEnabled = lib.any (x: x) [
    cfg.base
    cfg.qtcreator
  ];
in
{
  options.myConfig.apps.development.qt6 = {
    base = moduleHelpers.mkDisabledOption "Install Qt6 base libraries and tools";
    qtcreator = moduleHelpers.mkDisabledOption "Install Qt Creator IDE";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}

