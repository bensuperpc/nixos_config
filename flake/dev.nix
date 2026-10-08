# Development outputs: formatter (`nix fmt`), packages and devshells (`nix develop .#<name>`).
{ inputs, ... }:
{
  perSystem =
    {
      pkgs,
      pkgsSets,
      system,
      ...
    }:
    {
      formatter = pkgs.nixfmt-tree;

      packages = import ../pkgs pkgs;

      devShells = import ../devshells {
        inherit pkgsSets;
        espIdf = inputs.nixpkgs-esp-dev.packages.${system}.esp-idf-riscv;
      };
    };
}
