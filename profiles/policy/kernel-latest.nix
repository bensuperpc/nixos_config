{ lib, ... }:
{
  myConfig.boot.kernel = lib.mkDefault "latest";
}
