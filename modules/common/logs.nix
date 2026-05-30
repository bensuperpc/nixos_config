{ config, lib, moduleHelpers, ... }:

{
  services.journald = {
    storage = "persistent";
  };
}