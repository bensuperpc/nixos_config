{ lib, ... }:
{
  mkEnabledOption = description:
    (lib.mkEnableOption description) // {
      default = true;
    };
  mkDisabledOption = description:
    (lib.mkEnableOption description) // {
      default = false;
    };
}
