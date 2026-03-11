{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    man
    stdmanpages
    llvm-manpages
    clang-manpages
    man-pages
    man-pages-posix
    texinfo
  ];
}