{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.libraries;
  basePackages = with pkgs; [ ];
  commonPackages = with pkgs; [
    boost
    abseil-cpp
    qpdf
    loguru
    fmt
  ];
  dataFormatPackages = with pkgs; [
    libxml2
    expat
    jsoncpp
    simdjson
    nlohmann_json
    simdutf
  ];
  embeddedPackages = with pkgs; [
    can-utils
    pico-sdk
    pioasm
  ];
  numericPackages = with pkgs; [
    openblas
    physac
    imath
    muparser
    eigen
  ];
  graphicsPackages = with pkgs; [
    waylandpp
    libdrm
    sdl3
    sdl2-compat
    opencv
    tesseract
    raylib
    glew
    pkgs-stable.imgui
  ];
  computePackages = with pkgs; [
    kompute
    vulkan-loader
    ocl-icd
    opencl-headers
    opencl-clhpp
  ];
  cryptoPackages = with pkgs; [
    mbedtls
    openssl
    wolfssl
    libressl
    xxHash
  ];
  testingPackages = with pkgs; [
    catch2
    doctest
    gtest
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.common commonPackages
    ++ lib.optionals cfg.dataFormats dataFormatPackages
    ++ lib.optionals cfg.embedded embeddedPackages
    ++ lib.optionals cfg.numeric numericPackages
    ++ lib.optionals cfg.graphics graphicsPackages
    ++ lib.optionals cfg.compute computePackages
    ++ lib.optionals cfg.crypto cryptoPackages
    ++ lib.optionals cfg.testing testingPackages;

  anyEnabled = lib.any (x: x) [
    cfg.common
    cfg.dataFormats
    cfg.embedded
    cfg.numeric
    cfg.graphics
    cfg.compute
    cfg.crypto
    cfg.testing
  ];
in
{
  options.myConfig.apps.development.libraries = {
    common = moduleHelpers.mkEnabledOption "Install common native development libraries";

    dataFormats = moduleHelpers.mkEnabledOption "Install structured data and parsing libraries (JSON/XML/UTF)";

    embedded = moduleHelpers.mkEnabledOption "Install embedded and hardware-oriented development libraries";

    numeric = moduleHelpers.mkEnabledOption "Install numeric and scientific development libraries";

    graphics = moduleHelpers.mkEnabledOption "Install graphics, multimedia, and UI libraries";

    compute = moduleHelpers.mkEnabledOption "Install compute, Vulkan, and OpenCL libraries";

    crypto = moduleHelpers.mkEnabledOption "Install crypto and TLS libraries";

    testing = moduleHelpers.mkEnabledOption "Install C/C++ testing libraries";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = lib.unique enabledOptionalsPackages;
    })
  ];
}
