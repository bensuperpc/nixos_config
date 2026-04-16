# profiles/development.nix — compilers, IDEs, languages and dev tooling.
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-dev.nix
  ];

  myConfig.apps.development.dev = {
    core = lib.mkDefault true;
    tooling = lib.mkDefault true;
    graphics = lib.mkDefault true;
    dotnet = lib.mkDefault true;
    misc = lib.mkDefault true;
  };

  myConfig.apps.development.libraries = {
    common = lib.mkDefault true;
    dataFormats = lib.mkDefault true;
    embedded = lib.mkDefault true;
    numeric = lib.mkDefault true;
    graphics = lib.mkDefault true;
    compute = lib.mkDefault true;
    crypto = lib.mkDefault true;
    testing = lib.mkDefault true;
  };

  myConfig.apps.development.compilers = {
    native = lib.mkDefault true;
    lowLevel = lib.mkDefault true;
    wasm = lib.mkDefault true;
    embedded = lib.mkDefault true;
    stdenvs = lib.mkDefault true;
  };

  myConfig.apps.development.bdd = {
    relational = lib.mkDefault true;
    kv = lib.mkDefault true;
  };

  myConfig.apps.development.qt6 = {
    base = lib.mkDefault true;
    qtcreator = lib.mkDefault true;
  };

  myConfig.apps.development.python = {
    core = lib.mkDefault true;
    dataScience = lib.mkDefault true;
    web = lib.mkDefault true;
    automation = lib.mkDefault true;
    testing = lib.mkDefault true;
  };

  myConfig.apps.development.modeling = {
    engines = lib.mkDefault true;
    modeling = lib.mkDefault true;
  };
  myConfig.apps.development.ide.enable = lib.mkDefault true;

  myConfig.apps.development.documentation = {
    manpages = lib.mkDefault true;
    generators = lib.mkDefault true;
  };

  myConfig.apps.development.benchmark.enable = lib.mkDefault true;

  myConfig.apps.development.nixtools = {
    cache = lib.mkDefault true;
    pinning = lib.mkDefault true;
    analysis = lib.mkDefault true;
  };

  myConfig.apps.development.ctools = {
    caching = lib.mkDefault true;
    buildSystems = lib.mkDefault true;
    quality = lib.mkDefault true;
    debugging = lib.mkDefault true;
  };

  myConfig.apps.development.rust.toolchain = lib.mkDefault true;
  myConfig.apps.development.go.toolchain = lib.mkDefault true;
}
