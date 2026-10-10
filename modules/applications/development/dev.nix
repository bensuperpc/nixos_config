{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.dev;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      base = {
        description = "Install base development system tools";
        packages = with pkgs; [
          git
          autoconf
          automake
          binutils
          bison
          debugedit
          fakeroot
          file
          flex
          gcc
          gettext
          groff
          libtool
          m4
          gnumake
          cmake
          pkgconf
          texinfo
          ninja
        ];
      };
      tooling = {
        description = "Install general development CLIs and review tools";
        packages = with pkgs; [
          shellcheck
          codechecker
          gource
          lazygit
          commitizen
        ];
      };
      graphics = {
        description = "Install graphics, Vulkan, and OpenCL diagnostics";
        packages = with pkgs; [
          vulkan-tools
          vulkan-cts
          mesa-demos
          virtualgl
        ];
      };
      dotnet = {
        description = "Install Mono and .NET development tooling";
        packages = with pkgs; [
          mono
          dotnet-sdk
        ];
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
  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.graphics {
      hardware.graphics.extraPackages = [ pkgs.mesa.opencl ];
    })
  ];
}
