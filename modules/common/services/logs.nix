{ options, ... }:
{
  # nixos-26.05 does not have services.journald.settings yet.
  services.journald =
    if options.services.journald ? settings then
      { settings.Journal.Storage = "persistent"; }
    else
      { storage = "persistent"; };
}
