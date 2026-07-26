{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.qt6;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      base = {
        description = "Install Qt6 base libraries and tools";
        # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/qt-6/default.nix
        packages = with pkgs.qt6; [
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
      };
      qtcreator = {
        description = "Install Qt Creator IDE";
        packages = with pkgs; [ qtcreator ];
      };
    };
  };
in
{
  options.myConfig.apps.development.qt6 = generated.options;
  inherit (generated) config;
}
