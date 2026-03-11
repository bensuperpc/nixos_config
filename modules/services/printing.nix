{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      # pkgs.nixpkgs-stable.hplip
      # pkgs.nixpkgs-stable.hplipWithPlugin
    ];
  };

  # Scanners
  #hardware.sane.enable = true;
}