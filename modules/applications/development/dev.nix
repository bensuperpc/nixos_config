{ config, lib, pkgs, moduleHelpers, pkgsSets, ... }:

let
  cfg = config.myConfig.apps.development.dev;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      tooling = {
        description = "Install general development CLIs and review tools";
        packages = with pkgs; [ shellcheck codechecker gource lazygit ] ++ (with pkgsSets.stable-2511; [
          commitizen
        ]);
      };
      graphics = {
        description = "Install graphics, Vulkan, and OpenCL diagnostics";
        packages = with pkgs; [ vulkan-tools vulkan-cts mesa.opencl mesa-demos virtualgl ];
      };
      dotnet = {
        description = "Install Mono and .NET development tooling";
        packages = with pkgs; [ mono dotnet-sdk ];
      };
      misc = {
        description = "Install auxiliary developer applications";
        packages = with pkgs; [ postman ];
      };
    };
  };
in
{
  options.myConfig.apps.development.dev = generated.options;
  config = generated.config;
}
