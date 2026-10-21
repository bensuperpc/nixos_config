{
  perSystem =
    {
      pkgs,
      pkgsSets,
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
