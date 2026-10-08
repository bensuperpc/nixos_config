{ moduleHelpers, ... }:
{
  myConfig = moduleHelpers.mkDefaults {
    gui.plasma.games = true;

    apps.games = {
      emulator = {
        nintendo = true;
        sony = true;
        retro = true;
        xbox = true;
        sega = true;
      };

      steam = {
        client = true;
        performanceTools = true;
        protonGE = true;
        ntsync = true;
      };

      minecraft = {
        launcher = true;
        tools = true;
      };

      games = {
        fps = true;
        arcade = true;
        sandbox = true;
        strategy = true;
        others = true;
        launchers = true;
      };
    };
  };
}
