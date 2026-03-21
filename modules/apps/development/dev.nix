{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.development.dev;
  basePackages = with pkgs; [
    git
  ];
  corePackages = with pkgs; [
  ];
  toolingPackages = with pkgs; [
    clang-analyzer
    clang-tools
    shellcheck
    codechecker
    commitizen
    gource
  ];
  graphicsPackages = with pkgs; [
    vulkan-tools
    vulkan-cts
    mesa.opencl
    mesa-demos
    virtualgl
  ];
  dotnetPackages = with pkgs; [
    mono
    dotnet-sdk
  ];
  miscPackages = with pkgs; [
    postman
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.core corePackages
    ++ lib.optionals cfg.tooling toolingPackages
    ++ lib.optionals cfg.graphics graphicsPackages
    ++ lib.optionals cfg.dotnet dotnetPackages
    ++ lib.optionals cfg.misc miscPackages;

  anyEnabled = lib.any (x: x) [
    cfg.core
    cfg.tooling
    cfg.graphics
    cfg.dotnet
    cfg.misc
  ];
in
{
  options.myConfig.apps.development.dev = {
    core = moduleHelpers.mkEnabledOption "Install base development system tools";

    tooling = moduleHelpers.mkEnabledOption "Install general development CLIs and review tools";

    graphics = moduleHelpers.mkEnabledOption "Install graphics, Vulkan, and OpenCL diagnostics";

    dotnet = moduleHelpers.mkEnabledOption "Install Mono and .NET development tooling";

    misc = moduleHelpers.mkEnabledOption "Install auxiliary developer applications";
  };

  config = lib.mkIf anyEnabled {
    environment.systemPackages = enabledOptionalsPackages;
  };
}