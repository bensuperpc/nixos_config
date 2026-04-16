{ config, lib, moduleHelpers, ... }:

let
  trustedUsers = [
    "@wheel"
  ];

  baseSubstituters = [
    "https://cache.nixos.org"
  ];
  baseTrustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  communitySubstituters = [
    "https://nix-community.cachix.org"
  ];
  communityTrustedPublicKeys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  cfg = config.myConfig.system.nixos;
in
{
  options.myConfig.system.nixos.enableCommunitySubstituters =
    moduleHelpers.mkDisabledOption "Enable community substituters for Nix";

  config = {
    warnings = lib.optionals cfg.enableCommunitySubstituters [
      "You enabled community substituters for Nix, be careful and make sure you trust the sources you are downloading from!"
    ];

    services.fstrim.enable = true;

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        download-buffer-size = 268435456;
        auto-optimise-store = true;
        max-jobs = "auto";
        cores = 0;

        #build-dir = "/var/tmp";

        # Force all packages to be built from source, bypassing the binary cache
        # substituters = [ ];
        # trusted-public-keys = [ ];

        # Disable building local packages
        # fallback = false;

        allowed-users = trustedUsers;
        trusted-users = trustedUsers;

        substituters = baseSubstituters ++ lib.optionals cfg.enableCommunitySubstituters communitySubstituters;
        trusted-public-keys = baseTrustedPublicKeys ++ lib.optionals cfg.enableCommunitySubstituters communityTrustedPublicKeys;
      };

      optimise = {
        automatic = true;
        dates = [ "5:00" ];
        randomizedDelaySec = "45min";
      };
    };
  };
}