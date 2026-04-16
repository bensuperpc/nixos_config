{ config, lib, pkgs, moduleHelpers, ... }:

let
  nixWheelUsers = [
    "@wheel"
  ];

  nixSubstituters = [
    "https://cache.nixos.org"
  ];
  trustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
  ];

  communityNixSubstituters = [
    "https://nix-community.cachix.org"
  ];
  communityKeys = [
    "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];

  cfg = config.myConfig.system.nixos;
in
{
  options.myConfig.system.nixos = {
    enableGarbageCollector = moduleHelpers.mkEnabledOption "Enable automatic garbage collection for Nix";
    enableAutoUpgrade = moduleHelpers.mkDisabledOption "Enable automatic system upgrades";
    enableCommunitySubstituters = moduleHelpers.mkDisabledOption "Enable community substituters for Nix";
  };
  config = lib.mkMerge [
    {
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

          # Force all packages to be built from source, bypassing the binary cache
          # substituters = [ ];
          # trusted-public-keys = [ ];
          
          # Disable building local packages
          # fallback = false;

          allowed-users = nixWheelUsers;
          trusted-users = nixWheelUsers;

          substituters = nixSubstituters ++ lib.optionals cfg.enableCommunitySubstituters communityNixSubstituters;
          trusted-public-keys = trustedPublicKeys ++ lib.optionals cfg.enableCommunitySubstituters communityKeys;
        };
        optimise = {
          automatic = true;
          dates = [ "5:00" ];
          randomizedDelaySec = "45min";
        };
      };
      # Fix change dbus to dbus-broker
      services.dbus.implementation = "broker";

      zramSwap = {
        enable = true;
        algorithm = "zstd";
        memoryPercent = 50;
      };

      security = {
        # Needed for KDE/Gnome GUI
        # polkit.enable = true;

        # Protect the kernel image from accidental deletion or modification
        protectKernelImage = true;

        # can break iptables, wireguard, and virtd
        lockKernelModules = false;

        # Enable user namespaces for better security in containerized environments (e.g. Docker, Podman, etc.)
        allowUserNamespaces = true;
      };
    }
    (lib.mkIf cfg.enableGarbageCollector {
      nix = {
        gc = {
          automatic = true;
          persistent = true;
          randomizedDelaySec = "45min";
          dates = [ "weekly" ];
          options = "--delete-older-than 30d";
        };
      };
    })
    (lib.mkIf cfg.enableAutoUpgrade {
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
          flake = "github:bensuperpc/nix_config/main";
          randomizedDelaySec = "45min";
        };
      };
    })
  ];
  
  # services.nix-serve = {
  #   enable = true;
  #   port = 5000;
  # };

  # nix.distributedBuilds = false;
  # nix.buildMachines = [
  #   {
  #     hostName = buildHost;
  #     system = "x86_64-linux";
  #     protocol = "ssh-ng";
  #     systems = ["x86_64-linux"];
  #     maxJobs = 16;
  #     speedFactor = 2;
  #     supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #     mandatoryFeatures = [ ];
  #   }
  # ];
}