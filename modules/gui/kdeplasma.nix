{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.gui.kdeplasma;
in {
  options.myConfig.apps.gui.kdeplasma = {
    enable = lib.mkEnableOption "Activate KDE Plasma Desktop Environment";
  };

  config = lib.mkIf cfg.enable {
    security = {
        # Needed for KDE/Gnome GUI
        polkit.enable = true;
    };
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

    # Disable udiskie, already include in plasma

    environment.systemPackages = with pkgs;
    [
      # Theme and icons
      kdePackages.breeze
      kdePackages.breeze-gtk
      kdePackages.breeze-icons
      kdePackages.breeze-plymouth
      kdePackages.oxygen
      kdePackages.oxygen-icons
      kdePackages.oxygen-sounds

      # Core KDE frameworks and runtime components
      kdePackages.extra-cmake-modules
      kdePackages.kcodecs
      kdePackages.kcoreaddons
      kdePackages.kded
      kdePackages.kdoctools
      kdePackages.kfilemetadata
      kdePackages.kguiaddons
      kdePackages.kholidays
      kdePackages.kidletime
      kdePackages.knewstuff
      kdePackages.solid
      kdePackages.karchive
      kdePackages.dolphin-plugins
      kdePackages.dolphin

      # Desktop integration and shell
      kdePackages.flatpak-kcm
      kdePackages.kdeconnect-kde
      kdePackages.plasma-browser-integration
      kdePackages.plasma-keyboard
      kdePackages.plasma-thunderbolt
      kdePackages.plasma-welcome
      kdePackages.qtvirtualkeyboard
      kdePackages.sddm-kcm

      # Hardware and power management
      kdePackages.bluedevil
      kdePackages.plasma-disks
      kdePackages.powerdevil
      kdePackages.wacomtablet

      # File manager and KIO helpers
      kdePackages.kio-admin
      kdePackages.kio-extras
      kdePackages.kio-fuse
      kdePackages.kio-gdrive

      # Productivity and utilities
      hardinfo2
      kdiff3
      kdePackages.ark
      kdePackages.discover
      kdePackages.filelight
      kdePackages.isoimagewriter
      kdePackages.kate
      kdePackages.kcalc
      kdePackages.kcharselect
      kdePackages.kclock
      kdePackages.kcolorchooser
      kdePackages.kdevelop
      kdePackages.kdialog
      kdePackages.kfind
      kdePackages.kget
      kdePackages.kleopatra
      kdePackages.kolourpaint
      kdePackages.ksystemlog
      kdePackages.kwallet
      kdePackages.kwalletmanager
      kdePackages.partitionmanager
      kdePackages.umbrello
      kdePackages.yakuake
      kdePackages.threadweaver
      # kdePackages.neochat # Unsafe due olm dependency
      kdePackages.massif-visualizer
      kdePackages.marble
      kdePackages.lokalize
      kdePackages.ksystemstats
      kdePackages.kstatusnotifieritem
      kdePackages.krunner
      kdePackages.krfb
      kdePackages.korganizer
      kdePackages.konsole
      kdePackages.konqueror
      kdePackages.kmouth
      kdePackages.kmousetool
      kdePackages.kmag
      kdePackages.klevernotes
      kdePackages.kjournald
      kdePackages.kdiagram
      kdePackages.kdf
      kdePackages.kcron
      kdePackages.kcrash
      kdePackages.kcompletion
      kdePackages.kbackup
      kdePackages.kalarm
      kdePackages.kaccounts-integration
      kdePackages.calligra
      kdePackages.baloo
      kdePackages.akonadi

      # Printing and scanning
      kdePackages.skanpage
      kdePackages.print-manager

      # Multimedia and graphics
      kdePackages.elisa
      kdePackages.gwenview
      kdePackages.kdegraphics-thumbnailers
      kdePackages.kdenlive
      kdePackages.kimageannotator
      kdePackages.koko
      kdePackages.kwave
      kdePackages.mpvqt
      kdePackages.spectacle
      kdePackages.okular
      kdePackages.kup
      kdePackages.krecorder
      kdePackages.kpipewire
      kdePackages.kmix
      kdePackages.kamoso
      kdePackages.k3b
      kdePackages.dragon
      # CD/DVD
      kdePackages.audex
      kdePackages.audiocd-kio

      # Communication and networking
      kdePackages.kdepim-runtime
      kdePackages.ktorrent

      # Education and science
      # kdePackages.itinerary # Unsafe due olm dependency
      kdePackages.kcalutils
      kdePackages.step
      kdePackages.kig
      kdePackages.kgeography
      kdePackages.klettres
      kdePackages.kbruch
      kdePackages.kalk
      kdePackages.kalgebra
      kdePackages.cantor
      kdePackages.artikulate

      # Games
      kdePackages.kblackbox
      kdePackages.kblocks
      kdePackages.kbreakout
      kdePackages.kigo
      kdePackages.kmahjongg
      kdePackages.kmines
      kdePackages.kollision
      kdePackages.kpat
      kdePackages.ksudoku
      kdePackages.ktuberling
      kdePackages.skladnik
      kdePackages.picmi
      kdePackages.palapeli
      kdePackages.lskat
      kdePackages.kwordquiz
      kdePackages.kubrick
      kdePackages.kdiamond
      kdePackages.ksirk
      kdePackages.klickety
      kdePackages.klines
      kdePackages.granatier
      kdePackages.blinken

      # Wayland utilities
      wayland-utils
      wl-clipboard
    ];

    hardware.graphics.enable = true; 
  };
}
