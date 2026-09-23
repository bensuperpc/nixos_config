{
  pkgs,
  espIdf,
  target,
}:

pkgs.mkShell {
  name = "esp-idf-${target}";

  # Its setup hook exports IDF_PATH, IDF_TOOLS_PATH, the toolchain and the Python env with idf.py.
  packages = [ espIdf ];

  IDF_TARGET = target;

  shellHook = ''
    echo "$(idf.py --version 2>/dev/null) for ${target} (IDF_TARGET=${target})"
    echo "Example (tests/esp-idf/README.md): idf.py -B build/$IDF_TARGET -D SDKCONFIG=build/$IDF_TARGET/sdkconfig build"
  '';
}

# nix develop .#esp32c6
# cd tests/esp-idf
# idf.py -B build/$IDF_TARGET -D SDKCONFIG=build/$IDF_TARGET/sdkconfig build
# idf.py -B build/$IDF_TARGET -D SDKCONFIG=build/$IDF_TARGET/sdkconfig -p /dev/ttyACM0 flash monitor
