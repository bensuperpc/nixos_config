{ lib, ... }:
{
  myConfig.system.kernel = lib.mkDefault "latest";
}
