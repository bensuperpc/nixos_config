{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

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
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Activate benchmarking and related tools";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = benchmarkPackages;
  };
}
