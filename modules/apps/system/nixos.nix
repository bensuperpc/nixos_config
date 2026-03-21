{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  nixWheelUsers = [
    "@wheel"
    "${vars.admin.user}"
  ];

  nixSubstituters = [
    "https://cache.nixos.org"
    # "https://nix-community.cachix.org"
  ];

  trustedPublicKeys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    # "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
  ];
in
{

  options.myConfig.system.nixos = {
    enableGarbageCollector = moduleHelpers.mkEnabledOption "Enable automatic garbage collection for Nix";
    enableAutoUpgrade = moduleHelpers.mkDisabledOption "Enable automatic system upgrades";
  };
  config = lib.mkMerge [
    {
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

          substituters = nixSubstituters;
          trusted-public-keys = trustedPublicKeys;
        };
        optimise = {
          automatic = true;
          dates = [ "5:00" ];
          randomizedDelaySec = "45min";
        };
      };
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
    (lib.mkIf config.myConfig.system.nixos.enableGarbageCollector {
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
    (lib.mkIf config.myConfig.system.nixos.enableAutoUpgrade {
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