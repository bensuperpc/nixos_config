{ pkgs, inputs, vars, ... }:

{
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    postman
    # Compilers and build tools
    gcc15
    clang
    clang-analyzer
    clang-tools
    python314Packages.ninja
    gdb
    valgrind
    gcovr
    doxygen
    shellcheck
    cppcheck
    cmake
    lomiri.cmake-extras
    ccache
    sccache
    distcc
    mold-wrapped
    # Python
    python314
    pipx
    # 3D graphics
    vulkan-tools
    godot
    # 3D modeling
    blender
    # Git history visualizer
    gource
    virt-manager
  ];
}