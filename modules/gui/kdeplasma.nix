{ pkgs, inputs, vars, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  
  services.displayManager.sddm.autoNumlock = true;
  services.displayManager.sddm.enable = true;
  services.displayManager.sddm.wayland.enable = true;
  services.displayManager.sddm.settings.General.DisplayServer = "wayland";

  services.xserver.enable = true;

  environment.systemPackages = with pkgs;
  [
    # KDE
    #Theme
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.oxygen
    # Kde Applications
    kdePackages.kdevelop
    kdePackages.ark
    kdePackages.kdenlive
    kdePackages.kate
    kdePackages.discover
    kdePackages.kcalc
    kdePackages.kcharselect
    kdePackages.kclock
    kdePackages.kcolorchooser
    kdePackages.kolourpaint
    kdePackages.ksystemlog
    kdePackages.sddm-kcm
    kdePackages.isoimagewriter
    kdePackages.partitionmanager
    kdePackages.ktorrent
    kdePackages.elisa
    kdePackages.kdepim-runtime
    kdePackages.gwenview
    kdePackages.kdeconnect-kde
    kdePackages.koko
    kdePackages.qtvirtualkeyboard
    kdePackages.kget
    kdePackages.kfind
    kdePackages.mpvqt
    kdePackages.flatpak-kcm
    kdePackages.extra-cmake-modules
    wayland-utils
    wl-clipboard
    kdiff3
    hardinfo2
    # Games
    kdePackages.kpat
    kdePackages.ksudoku
    kdePackages.kmines
    kdePackages.kmahjongg
    kdePackages.kigo
    kdePackages.kblocks
  ];
}


