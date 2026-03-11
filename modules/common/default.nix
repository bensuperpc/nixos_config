{ lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  imports = [
    ./hardware.nix
    ./boot.nix
    ./environment.nix
    ./audio.nix
    ./firmware.nix
    ./nixos.nix
    ./font.nix
    ./locales.nix
    ./networking.nix
  ];

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.flatpak.enable = true;

  # For SSD optimization
  services.fstrim.enable = true;

  services.logrotate.enable = true;

  # Enable udisks2 for automounting and managing disks.
  services.devmon.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  services.power-profiles-daemon.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  # services.tlp.enable = true;

  # services.restic.backups = {
  #   home = {
  #     initialize = true;
  #     user = "restic";
  #     paths = [ "/home" ];
  #     repository = "";
  #     timerConfig = {
  #       onCalendar = "00:05";
  #       Persistent = true;
  #       RandomizedDelaySec = "1h";
  #     };
  #     passwordFile = "";
  #   };
  # };
}