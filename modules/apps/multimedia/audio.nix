{ pkgs, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Audio editing
    tenacity
  ];
}