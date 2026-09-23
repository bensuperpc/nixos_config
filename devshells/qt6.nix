{ pkgs }:

pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    qt6.wrapQtAppsHook
    makeWrapper
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
    bashdir=$(mktemp -d)
    makeWrapper "$(type -p bash)" "$bashdir/bash" "''${qtWrapperArgs[@]}"
    trap 'rm -rf "$bashdir"' EXIT

    exec "$bashdir/bash"
  '';
}
