{ config, lib, pkgs, ... }:
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
in
{

  # programs.dconf.enable = true;

  environment.systemPackages = toolsPackages;

  programs.yazi = {
    enable = true;
  };
}

