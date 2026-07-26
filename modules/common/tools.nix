{
  config,
  lib,
  pkgs,
  ...
}:
let
  toolsPackages = with pkgs; [
    wget
    curl
    tree
    parallel
    cryptsetup
    coreutils-full
    rsync
    zstd
    btop
    xdelta
    xz
    tmux
    fastfetch # System information tool
    fio # Benchmarking tool for storage devices
    yazi # CLI file manager
  ];

  nixToolsPackages = with pkgs; [
    nix-du
  ];
in
{
  # programs.dconf.enable = true;

  environment.systemPackages = toolsPackages ++ nixToolsPackages;

  programs = {
    # nix-ld and nix-ld.dev are mutually exclusive.
    # nix-ld.enable = true;
    nix-ld.dev.enable = true;

    nh.enable = true;

    yazi.enable = true;
  };
}
