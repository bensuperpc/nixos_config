{
  lib,
  stdenv,
  fetchFromGitHub,

  cmake,
  ninja,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fastnoise2";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "Auburn";
    repo = "FastNoise2";
    rev = "v${finalAttrs.version}";
    hash = "sha256-bmJ2iTmAAEYSZgsyLU8ZJsRnM2LH/4a2ITKGFJEDdvY=";
  };

  fastSimdSrc = fetchFromGitHub {
    owner = "Auburn";
    repo = "FastSIMD";
    rev = "16450dae9528727e500e7254f635a671f9c7ee2d";
    hash = "sha256-86JqDMXbeK7Q0PgeFhKa7h2Jpl7Sa5tZNfyInhXF8tU=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
  ];

  cmakeFlags = [
    "-DFASTNOISE2_STANDALONE_PROJECT=OFF"
    "-DFASTNOISE2_TOOLS=OFF"
    "-DFASTNOISE2_TESTS=OFF"
    "-DFASTNOISE2_UTILITY=OFF"
    "-DFETCHCONTENT_SOURCE_DIR_FASTSIMD=${finalAttrs.fastSimdSrc}"
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
  ];

  meta = {
    description = "FastNoise2 library";
    homepage = "https://github.com/Auburn/FastNoise2";
    license = lib.licenses.mit;
  };
})
