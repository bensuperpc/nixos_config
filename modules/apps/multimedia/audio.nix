{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Audio editing
    tenacity
    beets
    audiowaveform
    lame
    audiosource
    # Audio CD extraction
    flacon
  ];
}