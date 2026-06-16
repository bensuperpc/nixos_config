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
  
  nixToolsPackages = with pkgs; [
    nix-du
  ];
in
{
  # programs.dconf.enable = true;

  environment.systemPackages = toolsPackages ++ nixToolsPackages;
  
  # nix-ld and nix-ld.dev are mutually exclusive.
  # programs.nix-ld.enable = true;
  programs.nix-ld.dev.enable = true;

  programs.nh.enable = true;

  programs.yazi = {
    enable = true;
  };
}

