{ lib, self, ... }:
{
  perSystem =
    { pkgs, system, ... }:
    let
      hosts = lib.filterAttrs (
        _: host: host.pkgs.stdenv.hostPlatform.system == system
      ) self.nixosConfigurations;
      toplevelOf = host: host.config.system.build.toplevel;

      lintCheck =
        name: tool: script:
        pkgs.runCommand name { nativeBuildInputs = [ tool ]; } ''
          cd ${self}
          ${script}
          touch $out
        '';

      lint = {
        deadnix = lintCheck "deadnix-check" pkgs.deadnix "deadnix --fail .";
        statix = lintCheck "statix-check" pkgs.statix "statix check .";
        format =
          lintCheck "format-check" pkgs.nixfmt
            "find . -name '*.nix' -print0 | xargs -0 nixfmt --check";
      };

      # Force full instantiation of each host without building
      evalChecks = lib.mapAttrs' (
        name: host:
        lib.nameValuePair "eval-${name}" (
          pkgs.writeText "eval-${name}" (builtins.unsafeDiscardStringContext (toplevelOf host).drvPath)
        )
      ) hosts;
      colmenaParity =
        let
          deployable = lib.intersectAttrs self.colmenaHive.toplevel hosts;
          differing = lib.attrNames (
            lib.filterAttrs (
              name: host: self.colmenaHive.toplevel.${name}.drvPath != (toplevelOf host).drvPath
            ) deployable
          );
        in
        if differing == [ ] then
          pkgs.writeText "colmena-parity" "ok"
        else
          throw "Colmena and nixosConfigurations build different systems for: ${toString differing}";

      # sops-nix catches a missing key
      sopsChecks = lib.mapAttrs' (
        name: host:
        lib.nameValuePair "sops-${name}" (
          pkgs.linkFarm "sops-${name}" {
            "manifest.json" = host.config.system.build.sops-nix-manifest;
            "manifest-for-users.json" = host.config.system.build.sops-nix-users-manifest;
          }
        )
      ) (lib.filterAttrs (_: host: host.config.sops.secrets != { }) hosts);
    in
    {
      checks =
        import ../modules/applications/custom/packages pkgs
        // lint
        // {
          colmena-parity = colmenaParity;
        }
        // evalChecks
        // sopsChecks;
    };
}
