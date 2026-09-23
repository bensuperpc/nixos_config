# Development outputs: formatter (`nix fmt`) and devshells (`nix develop .#<name>`).
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

      devShells = import ../devshells {
        inherit pkgs pkgsSets;
        espIdf = inputs.nixpkgs-esp-dev.packages.${system}.esp-idf-riscv;
      };
    };
}
