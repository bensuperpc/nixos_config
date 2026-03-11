{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates =  [ "03:00" ];
      options = "--delete-older-than 14d";
    };
    
    settings = {
      experimental-features = [ "nix-command" "flakes" ];
      download-buffer-size = 268435456;
      auto-optimise-store = true;
      max-jobs = "auto";
      cores = 0;

      # Force all packages to be built from source, bypassing the binary cache
      # substituters = [ ];
      # trusted-public-keys = [ ];
      
      # Disable building local packages
      # fallback = false;

      allowed-users = [
        "@wheel"
        "${vars.admin.user}"
      ];
      trusted-users = [
        "@wheel"
        "${vars.admin.user}"
      ];

      substituters = [
        "https://cache.nixos.org"
        # "https://nix-community.cachix.org"
      ];
      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };

    optimise.automatic = true;
    optimise.dates = [ "5:00" ];
  };

  system = {
    autoUpgrade = {
      enable = false;
      dates = "00:00";
      allowReboot = true;
      # rebootWindow = {
      #   lower = "01:00";
      #   upper = "05:00";
      # };
      runGarbageCollection = true;
      persistent = true;
      #flake = "github:bensuperpc/nix";
      randomizedDelaySec = "45min";
    };
  };

  zramSwap.enable = true;
  zramSwap.algorithm = "zstd";
}