{ config, ... }:
{
  assertions = [
    {
      assertion = !(
        config.myConfig.drivers.gpu.intel.enableOldDriver
        || config.myConfig.drivers.gpu.intel.enableSkylakeDriver
        || config.myConfig.drivers.gpu.intel.enableXeDriver
        || config.myConfig.drivers.gpu.amd.enable
      );
      message = "platform/no-gpu conflicts with GPU presets: disable any platform/gpu-intel* profile and platform/gpu-amd.";
    }
  ];
}
