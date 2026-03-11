{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    postman
    # Compilers and build tools
    gcc
    nasm
    wasmi
    clang
    clang-analyzer
    clang-tools
    gdb
    valgrind
    gcovr
    doxygen
    shellcheck
    cppcheck
    codechecker
    commitizen
    cmake
    gnumake
    lomiri.cmake-extras
    rustup
    meson
    # C/C++ caching tools
    ccache
    sccache
    distcc
    mold
    vulkan-tools
    vulkan-cts
    mesa.opencl
    mesa-demos
    virtualgl
    # Git history visualizer
    gource
    # Nix package cache
    cachix
    niv
    npins
    nix-tree
    nix-diff
  ];
}