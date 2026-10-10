{ pkgs }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    qt6.wrapQtAppsHook
  ];
  packages = with pkgs; [
    cmake
    ninja
    gcc
    valgrind
    gdb
    qt6.qttools
    bashInteractive
  ];

  buildInputs =
    with pkgs;
    [
      gtest
      gbenchmark
      boost
      openssl
    ]
    ++ (with pkgs.qt6; [
      qtbase
      qtwebengine
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
      qtmqtt
      qtgrpc
      qtlottie
      qtserialbus
      qtserialport
      qttranslations
    ]);

  shellHook = ''
    exportQtWrapperArgs() {
      while [ $# -gt 0 ]; do
        if [ "$1" = --prefix ]; then
          export "$2=$4''${!2:+$3''${!2}}"
          shift 4
        else
          shift
        fi
      done
    }
    exportQtWrapperArgs "''${qtWrapperArgs[@]}"
    unset -f exportQtWrapperArgs
  '';
}
