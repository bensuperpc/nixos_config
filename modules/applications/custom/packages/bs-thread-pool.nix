# { pkgs ? import <nixpkgs> {} }:
{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "bs-thread-pool";
  version = "v5.1.0";
  src = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    rev = "bd4533f1f70c2b975cbd5769a60d8eaaea1d2233";
    sha256 = "sha256-/RMo5pe9klgSWmoqBpHMq2lbJsnCxMzhsb3ZPsw3aZw=";
  };
  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    runHook preInstall
   
    mkdir -p $out/include
    cp include/BS_thread_pool.hpp $out/include/BS_thread_pool.hpp
   
    runHook postInstall
  '';
  meta = with lib; {
    description = "BS::thread_pool: a fast, lightweight, modern, and easy-to-use C++17 / C++20 / C++23 thread pool library";
    homepage = "https://github.com/bshoshany/thread-pool";
    downloadPage = "https://github.com/bshoshany/thread-pool";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
    teams = [ ];
    changelog = "https://github.com/bshoshany/thread-pool/blob/master/CHANGELOG.md";
  };
}