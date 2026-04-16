{ config, lib, moduleHelpers, ... }:

let
  intelCfg = config.myConfig.drivers.gpu.intel;
  intelAnyEnabled = intelCfg.enableOldDriver || intelCfg.enableSkylakeDriver || intelCfg.enableXeDriver;
  intelEnabledCount = builtins.length (lib.filter (x: x) [ intelCfg.enableOldDriver intelCfg.enableSkylakeDriver intelCfg.enableXeDriver ]);
  amdEnabled = config.myConfig.drivers.gpu.amd.enable;
in
{
  imports = [
    ./intel.nix
    ./amd.nix
  ];

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