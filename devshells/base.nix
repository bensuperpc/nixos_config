{ pkgs }:

pkgs.mkShellNoCC {
  packages = with pkgs; [
    colmena
    sops
    age
    ssh-to-age
    mkpasswd
    jq
    nixfmt-tree
    deadnix
    statix
  ];
}
