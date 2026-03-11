{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Benchmarking
    stress-ng
    phoronix-test-suite
  ];
}