{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # F2FS tools
    f2fs-tools
    ssdfs-utils
    # BTRFS tools
    btrfs-snap
    btrfs-list
    btrfs-assistant
    # Fat32 tools
    dosfstools
    exfat
    exfatprogs
  ];
}