{ config, lib, pkgs, ... }:
{

  programs.dconf.enable = true;

  environment.systemPackages = with pkgs; [
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

  programs.yazi = {
    enable = true;
    # plugins = with pkgs.yaziPlugins; [
    #   git
    #   diff
    #   sudo
    #   dupes
    #   mount
    #   rsync
    # ];
  };
}

