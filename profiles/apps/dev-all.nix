{
  lib,
  ...
}:
{

  myConfig.apps.development = {
    dev = {
      tooling = lib.mkDefault true;
      graphics = lib.mkDefault true;
      dotnet = lib.mkDefault true;
      misc = lib.mkDefault true;
      base = lib.mkDefault true;
    };

    compilers = {
      clang = lib.mkDefault true;
      lowLevel = lib.mkDefault true;
      protobuf = lib.mkDefault true;
      wasm = lib.mkDefault true;
      embedded = lib.mkDefault true;
    };

    databases = {
      relational = lib.mkDefault true;
      kv = lib.mkDefault true;
    };

    qt6.qtcreator = lib.mkDefault true;

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
      nixos = lib.mkDefault true;
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

    rust.enable = lib.mkDefault true;
    go.enable = lib.mkDefault true;
  };
}
