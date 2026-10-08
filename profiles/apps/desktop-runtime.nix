{ moduleHelpers, ... }:
{
  myConfig.apps = moduleHelpers.mkDefaults {
    network.cli.enable = true;
    desktop.terminal.enable = true;
  };
}
