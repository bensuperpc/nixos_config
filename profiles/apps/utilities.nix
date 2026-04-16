# profiles/utilities.nix — system utilities, math tools and antivirus.
{ config, lib, pkgs, ... }:
{
  imports = [
    ../../tests/check-math.nix
  ];

  myConfig.apps.electronic = {
    design = true;
    diagnostics = true;
  };
  myConfig.apps.flashing.tools = true;

  myConfig.apps.math = {
    geometry = true;
    plotting = true;
  };

  myConfig.apps.kvm.host = true;

  myConfig.apps.tools = {
    system = true;
    network = true;
    cli = true;
    security = true;
    archive = true;
  };

  myConfig.apps.compress = {
    base = true;
    tools = true;
  };

  myConfig.apps.antivirus.scanner = true;
}
