{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

let
  qtEnv = pkgs.qt6.env "qt6-simc-${pkgs.qt6.qtbase.version}" [
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/development/libraries/qt-6/default.nix
      pkgs.qt6.qtbase
      pkgs.qt6.qtwebengine
      pkgs.qt6.qttools
      pkgs.qt6.qtdeclarative
      pkgs.qt6.qt5compat
      pkgs.qt6.qtwebchannel
      pkgs.qt6.qtpositioning
      pkgs.qt6.qtsvg
      pkgs.qt6.qtmultimedia
      pkgs.qt6.qtimageformats
      pkgs.qt6.qtquick3d
      pkgs.qt6.qt3d
      pkgs.qt6.qtcharts
      pkgs.qt6.qtgraphs
      pkgs.qt6.qtscxml
      pkgs.qt6.qtwayland
      pkgs.qt6.qtspeech
      pkgs.qt6.qtsensors
      pkgs.qt6.qmake
      pkgs.qt6.qtmqtt
    ];
in
{
  environment.systemPackages = with pkgs; [
    # Libraries
    boost
    gtest
    abseil-cpp
    can-utils
    physac
    protobufc
    qpdf
    kompute
    loguru
    waylandpp
    blas
    # Crypto/SSL libraries
    mbedtls
    openssl
    wolfssl
    libressl
    # Image/video libraries
    sdl3
    sdl2-compat
    opencv
    tesseract
    raylib
    # Json libraries
    jsoncpp
    simdjson
    nlohmann_json
    # Qt environment
    qtEnv
    qt6.qtbase
    # Vulkan
    vulkan-loader
    # OpenGL
    glew
    # OpenCL
    ocl-icd
    opencl-headers
    opencl-clhpp
    # Snes
    # pvsneslib
    # Raspberry pico
    pico-sdk
    pioasm
  ];

  environment.sessionVariables = {
    QT_PLUGIN_PATH = "${qtEnv}/lib/qt-6/plugins";
    QML_IMPORT_PATH = "${qtEnv}/lib/qt-6/qml";
    QT_QPA_PLATFORM_PLUGIN_PATH = "${qtEnv}/lib/qt-6/plugins/platforms";
    PKG_CONFIG_PATH = "${qtEnv}/lib/pkgconfig:$PKG_CONFIG_PATH";
  };
}