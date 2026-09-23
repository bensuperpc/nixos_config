{
  lib,
  ...
}:
{

  myConfig.apps.games = {
    emulator = {
      nintendo = lib.mkDefault true;
      sony = lib.mkDefault true;
      retro = lib.mkDefault true;
      xbox = lib.mkDefault true;
      sega = lib.mkDefault true;
    };

    steam = {
      client = lib.mkDefault true;
      performanceTools = lib.mkDefault true;
      protonGE = lib.mkDefault true;
      ntsync = lib.mkDefault true;
    };

    minecraft = {
      launcher = lib.mkDefault true;
      jres = lib.mkDefault true;
      tools = lib.mkDefault true;
    };

    games = {
      fps = lib.mkDefault true;
      arcade = lib.mkDefault true;
      sandbox = lib.mkDefault true;
      strategy = lib.mkDefault true;
      others = lib.mkDefault true;
      launchers = lib.mkDefault true;
    };
  };
}
