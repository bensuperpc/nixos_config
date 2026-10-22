{ pkgs }:

(pkgs.buildFHSEnv {
  name = "esp32-riscv";

  targetPkgs =
    pkgs: with pkgs; [
      python3
      git
      wget
      flex
      bison
      gperf
      cmake
      ninja
      ccache
      dfu-util
      gcc
      libusb1
      libffi
      openssl
      zlib
      ncurses
      udev
      stdenv.cc.cc.lib
    ];

  profile = ''
    echo "Welcome to your Nix-managed ESP32 RISC-V (C5/C6) environment!"
    echo "First time: esp-idf/install.sh esp32c5,esp32c6"
    echo "Then:       esp-idf/export.sh"
  '';

  runScript = "bash";
}).env
