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
      };
    };
}
