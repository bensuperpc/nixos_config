{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.apps.development.documentation;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      manpages = {
        description = "Install manual pages and related documentation sets";
        packages = with pkgs; [
          man
          stdmanpages
          llvm-manpages
          clang-manpages
          man-pages
          man-pages-posix
          texinfo
        ];
      };
      generators = {
        description = "Install documentation generation and static site tools";
        packages = with pkgs; [
          doxygen
          zola
        ];
      };
    };
  };
in
{
  options.myConfig.apps.development.documentation = generated.options // {
    # Toggles NixOS's own manual/option-doc build, not a package group.
    nixosDocumentation = moduleHelpers.mkDisabledOption "Install NixOS manual pages";
  };

  config = lib.mkMerge [
    generated.config
    (lib.mkIf cfg.nixosDocumentation {
      documentation = {
        enable = true;
        dev.enable = true;
        doc.enable = false;
        info.enable = false;
        man.enable = true;
        nixos.enable = true;
      };
    })
  ];
}
