{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.libraries;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      common = {
        description = "Install common native development libraries";
        packages = with pkgs; [ boost abseil-cpp qpdf loguru fmt ];
      };
      dataFormats = {
        description = "Install structured data and parsing libraries (JSON/XML/UTF)";
        packages = with pkgs; [ libxml2 expat jsoncpp simdjson nlohmann_json simdutf ];
      };
      embedded = {
        description = "Install embedded and hardware-oriented development libraries";
        packages = with pkgs; [ can-utils pico-sdk pioasm ];
      };
      numeric = {
        description = "Install numeric and scientific development libraries";
        packages = with pkgs; [ openblas physac imath muparser eigen ];
      };
      graphics = {
        description = "Install graphics, multimedia, and UI libraries";
        packages = with pkgs; [
          waylandpp
          libdrm
          sdl3
          sdl2-compat
          opencv
          tesseract
          raylib
          glew
          xdg-utils-cxx
          imgui
        ];
      };
      compute = {
        description = "Install compute, Vulkan, and OpenCL libraries";
        packages = with pkgs; [ kompute vulkan-loader ocl-icd opencl-headers opencl-clhpp ];
      };
      crypto = {
        description = "Install crypto and TLS libraries";
        packages = with pkgs; [
          mbedtls
          openssl
          # wolfssl
          libressl
          sslh
          xxhash
        ];
      };
      testing = {
        description = "Install C/C++ testing libraries";
        packages = with pkgs; [ catch2 doctest gtest gbenchmark ];
      };
    };
  };
in
{
  options.myConfig.apps.development.libraries = generated.options;
  config = generated.config;
}
