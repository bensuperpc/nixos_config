{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # e-book readers
    calibre
    # PDF tools
    pdfarranger
  ];
}