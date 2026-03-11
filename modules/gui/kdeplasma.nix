{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  # Enable the KDE Plasma Desktop Environment.
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.plasma6.enableQt5Integration = true;
  
  services.displayManager = {
    plasma-login-manager = {
      enable = true; 
      settings = {
      };
    };
    autoLogin = {
      enable = false;
      user = "";
    };
  };

  services.xserver.enable = true;

  environment.systemPackages = with pkgs;
  [
    #Theme
    kdePackages.breeze
    kdePackages.breeze-gtk
    kdePackages.oxygen
    # Kde Applications
    kdePackages.kwave
    kdePackages.plasma-thunderbolt
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
    kdePackages.kwallet
    kdePackages.kwalletmanager
    kdePackages.plasma-browser-integration
    kdePackages.yakuake
    wayland-utils
    wl-clipboard
    kdiff3
    # Games
    kdePackages.kpat
    kdePackages.ksudoku
    kdePackages.kmines
    kdePackages.kmahjongg
    kdePackages.kigo
    kdePackages.kblocks
  ];
}


