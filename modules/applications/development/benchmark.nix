{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.development.benchmark;

  benchmarkPackages = with pkgs; [
    stress-ng
    phoronix-test-suite
    perf
  ];
in
{
  options.myConfig.apps.development.benchmark = {
    enable = moduleHelpers.mkDisabledOption "Activate benchmarking and related tools";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = benchmarkPackages;
  };
}
