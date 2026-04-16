{ config, lib, moduleHelpers, ... }:

let
  intelCfg = config.myConfig.drivers.gpu.intel;
  intelOldEnabled = intelCfg.enableOldDriver;
  intelSkylakeEnabled = intelCfg.enableSkylakeDriver;
  intelXeEnabled = intelCfg.enableXeDriver;
  intelAnyEnabled = intelOldEnabled || intelSkylakeEnabled || intelXeEnabled;
  intelEnabledCount = builtins.length (lib.filter (x: x) [ intelOldEnabled intelSkylakeEnabled intelXeEnabled ]);
  amdEnabled = config.myConfig.drivers.gpu.amd.enable;
in
{
  imports = [
    ./intel-driver.nix
    ./amd-driver.nix
  ];

  options.myConfig.drivers.gpu = {
    intel.enableOldDriver = moduleHelpers.mkDisabledOption "Enable Intel old driver stack for Haswell and older GPUs.";
    intel.enableSkylakeDriver = moduleHelpers.mkDisabledOption "Enable Intel driver stack for Skylake to Comet Lake GPUs.";
    intel.enableXeDriver = moduleHelpers.mkDisabledOption "Enable Intel Xe driver stack for Alder Lake and newer GPUs.";
    amd.enable = moduleHelpers.mkDisabledOption "Enable AMD GPU driver stack.";
  };

  config.assertions = [
    {
      assertion = intelEnabledCount <= 1;
      message = "Enable only one Intel preset at once: myConfig.drivers.gpu.intel.enableOldDriver, myConfig.drivers.gpu.intel.enableSkylakeDriver, or myConfig.drivers.gpu.intel.enableXeDriver.";
    }
    {
      assertion = !(intelAnyEnabled && amdEnabled);
      message = "Only one GPU preset should be enabled at once: Intel (old/skylake/xe) or AMD.";
    }
  ];
}