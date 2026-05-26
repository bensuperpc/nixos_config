{ config, ... }:
{
  assertions = [
    {
      assertion = config.myConfig.drivers.gpu.intel == "none" && !config.myConfig.drivers.gpu.amd.enable;
      message = "platform/no-gpu conflicts with a GPU profile: set myConfig.drivers.gpu.intel to \"none\" and disable myConfig.drivers.gpu.amd.enable.";
    }
  ];
}
