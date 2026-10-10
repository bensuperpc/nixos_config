{
  inputs,
  moduleHelpers,
  pkgsCache,
  channels,
}:

name: cfg:
let
  requirePath =
    what: path:
    if builtins.pathExists path then
      path
    else
      throw "Host '${name}' is missing ${what}: ${toString path}";

  profilesModules = map (p: requirePath "profile" ../profiles/${p}.nix) cfg.profiles;

  usersModules = map (u: requirePath "user system module" ../users/${u}/system.nix) cfg.users;

  varsHost = {
    name = cfg.systemName;
    inherit (cfg)
      role
      channel
      users
      deployUser
      ip
      port
      ageRecipient
      ;
  };

  pkgsSets =
    pkgsCache.${cfg.system} or (throw "Unsupported system '${cfg.system}' for host '${name}'.");

  modules = [
    (requirePath "system configuration" ../systems/${cfg.systemName}/configuration.nix)
    channels.${cfg.channel}.homeManager.nixosModules.home-manager
    inputs.impermanence.nixosModules.impermanence
    inputs.disko.nixosModules.disko
    inputs.sops-nix.nixosModules.sops
    inputs.lanzaboote.nixosModules.lanzaboote
    inputs.microvm.nixosModules.host
    inputs.nix-flatpak.nixosModules.nix-flatpak
    inputs.nix-index-database.nixosModules.nix-index
    {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        sharedModules = [
          inputs.plasma-manager.homeModules.plasma-manager
          inputs.nix-flatpak.homeManagerModules.nix-flatpak
        ];
        extraSpecialArgs = {
          inherit
            inputs
            moduleHelpers
            pkgsSets
            varsHost
            ;
        };
      };
      _module.args = { inherit pkgsSets varsHost; };
    }
    ../modules
  ]
  ++ profilesModules
  ++ usersModules;
in
{
  inherit modules;
  host = varsHost;
  inherit (cfg) system channel;
}
