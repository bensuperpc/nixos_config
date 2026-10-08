{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,

  zlib,
}:

stdenv.mkDerivation rec {
  pname = "libnbtplusplus";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "PrismLauncher";
    repo = "libnbtplusplus";
    rev = "687e43031df0dc641984b4256bcca50d5b3f7de3";
    hash = "sha256-7itkptyjoRcXfGLwg1/jxajetZ3a4mDc66+w4X6yW8s=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    zlib
  ];

  cmakeFlags = [
    "-DNBT_BUILD_TESTS=OFF"
    "-DNBT_DEST_DIR=ON"
    "-DLIBRARY_DEST_DIR=lib"
  ];

  postInstall = ''
    mkdir -p $out/include
    cp -r $src/include/. $out/include/
  '';

  meta = {
    description = "C++ library for NBT data";
    homepage = "https://github.com/PrismLauncher/libnbtplusplus";
    license = lib.licenses.gpl3Plus;
  };
}
