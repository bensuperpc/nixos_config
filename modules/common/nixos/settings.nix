{ config, lib, moduleHelpers, inputs, ... }:

let
  trustedUsers = [
    "root"
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

    environment.etc.nixos-current-system-flake-src.source = inputs.self;

    nix = {
      settings = {
        experimental-features = [ "nix-command" "flakes" ];
        connect-timeout = 3;
        log-lines = 25;
        download-buffer-size = 268435456; # 256 MiB
        min-free = 268435456; # 256 MiB
        max-free = 1073741824; # 1 GiB

        max-jobs = "auto";
        cores = 0;
        http-connections = 48;
        max-substitution-jobs = 32;

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

      # auto-optimise-store hardlinks the store synchronously after every
      # build, slowing each build down; this periodic timer does the same
      # deduplication asynchronously instead.
      optimise = {
        automatic = true;
        dates = [ "5:00" ];
        randomizedDelaySec = "45min";
      };
    };
  };
}