{
  config,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    #../../tests/check-dev.nix
  ];

  myConfig.apps.development = {
    dev = {
      tooling = lib.mkDefault true;
      graphics = lib.mkDefault true;
      dotnet = lib.mkDefault true;
      misc = lib.mkDefault true;
      base = lib.mkDefault true;
    };

    libraries = {
      common = lib.mkDefault true;
      dataFormats = lib.mkDefault true;
      embedded = lib.mkDefault true;
      numeric = lib.mkDefault true;
      graphics = lib.mkDefault true;
      compute = lib.mkDefault true;
      crypto = lib.mkDefault true;
      testing = lib.mkDefault true;
    };

    compilers = {
      clang = lib.mkDefault true;
      lowLevel = lib.mkDefault true;
      protobuf = lib.mkDefault true;
      wasm = lib.mkDefault true;
      embedded = lib.mkDefault true;
      stdenvs = lib.mkDefault true;
    };

    databases = {
      relational = lib.mkDefault true;
      kv = lib.mkDefault true;
    };

    qt6 = {
      base = lib.mkDefault true;
      qtcreator = lib.mkDefault true;
    };

    python = {
      core = lib.mkDefault true;
      dataScience = lib.mkDefault true;
      web = lib.mkDefault true;
      automation = lib.mkDefault true;
      testing = lib.mkDefault true;
      llm = lib.mkDefault true;
    };

    modeling = {
      engines = lib.mkDefault true;
      cad = lib.mkDefault true;
    };
    ide.enable = lib.mkDefault true;

    documentation = {
      manpages = lib.mkDefault true;
      generators = lib.mkDefault true;
      nixosDocumentation = lib.mkDefault true;
    };

    benchmark.enable = lib.mkDefault true;

    nixtools = {
      cache = lib.mkDefault true;
      pinning = lib.mkDefault true;
      analysis = lib.mkDefault true;
    };

    cppTools = {
      caching = lib.mkDefault true;
      buildSystems = lib.mkDefault true;
      quality = lib.mkDefault true;
      debugging = lib.mkDefault true;
    };

    rust.toolchain = lib.mkDefault true;
    go.toolchain = lib.mkDefault true;
  };
}
