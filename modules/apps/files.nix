{ pkgs, inputs, vars, ... }:
{
  # https://search.nixos.org/packages?channel=25.11&query=home
  environment.systemPackages = with pkgs; [
    veracrypt
    filezilla
    syncthing
    samba
    rsync
    sshfs
    # Backup tools
    restic
    rclone
  ];
}