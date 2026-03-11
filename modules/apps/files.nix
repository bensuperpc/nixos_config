{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  # https://search.nixos.org/packages?channel=25.11&query=home
  environment.systemPackages = with pkgs; [
    veracrypt
    adb-sync
    fsearch
    catfish
    recoll
    # File management/sync
    rclone
    filezilla
    syncthing
    syncthingtray
    samba
    rsync
    # Backup tools
    restic
    resticprofile
    restic-browser
    rustic
  ];
}