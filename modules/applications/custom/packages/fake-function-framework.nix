{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "fake-function-framework";
  version = "v1.2";
  src = fetchFromGitHub {
    owner = "meekrosoft";
    repo = "fff";
    rev = "5111c61e1ef7848e3afd3550044a8cf4405f4199";
    sha256 = "sha256-V5OVL8TbYJiZMEZYQhtuR0md/wVs4XAtlSK30GFcO9A=";
  };
  dontBuild = true;
  dontConfigure = true;
  installPhase = ''
    runHook preInstall
   
    mkdir -p $out/include
    cp fff.h $out/include/fff.h
   
    runHook postInstall
  '';
  meta = with lib; {
    description = "Fake Function Framework: a lightweight C testing framework";
    homepage = "https://github.com/meekrosoft/fff";
    downloadPage = "https://github.com/meekrosoft/fff";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = [ ];
    teams = [ ];
    changelog = "";
  };
}