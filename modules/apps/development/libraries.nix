{ pkgs, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Libraries
    boost
    opencv
    gtest
    abseil-cpp
    can-utils
    jsoncpp
    simdjson
    raylib
    physac
    mbedtls
    openssl
    libressl
    protobuf
    nlohmann_json
    qpdf
  ];
}