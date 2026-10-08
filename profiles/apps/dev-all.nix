{ moduleHelpers, ... }:
{
  myConfig = moduleHelpers.mkDefaults {
    gui.plasma.development = true;

    apps.development = {
      dev = {
        tooling = true;
        graphics = true;
        dotnet = true;
        misc = true;
        base = true;
      };

      databases = {
        relational = true;
        kv = true;
      };

      qt6.qtcreator = true;

      python = {
        core = true;
        dataScience = true;
        web = true;
        automation = true;
        testing = true;
        llm = true;
      };

      modeling = {
        engines = true;
        cad = true;
      };
      ide.enable = true;

      documentation = {
        manpages = true;
        generators = true;
        nixos = true;
      };

      benchmark.enable = true;

      nixtools = {
        cache = true;
        pinning = true;
        analysis = true;
      };

      cppTools = {
        caching = true;
        buildSystems = true;
        quality = true;
        debugging = true;
      };

      rust.enable = true;
      go.enable = true;
    };
  };
}
