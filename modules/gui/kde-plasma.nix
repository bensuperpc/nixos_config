{
  config,
  lib,
  pkgs,
  moduleHelpers,
  ...
}:

let
  cfg = config.myConfig.gui;

  # Only what services.desktopManager.plasma6 does not already install.
  generated = moduleHelpers.mkPackageGroupModule {
    cfg = cfg.plasma;
    groups = {
      integration = {
        description = "Install Plasma themes, KIO helpers, system tools and KDE Connect";
        packages = with pkgs; [
          kdePackages.breeze-plymouth
          kdePackages.oxygen
          kdePackages.oxygen-icons
          kdePackages.oxygen-sounds

          kdePackages.kholidays
          kdePackages.kidletime
          kdePackages.knewstuff
          kdePackages.krunner
          kdePackages.kpipewire
          kdePackages.kaccounts-integration
          kdePackages.kio-gdrive
          kdePackages.kio-snapshot
          kdePackages.kdialog

          kdePackages.plasma-disks
          kdePackages.plasma-thunderbolt
          kdePackages.plasma-welcome
          kdePackages.wacomtablet
          kdePackages.partitionmanager
          kdePackages.filelight
          kdePackages.isoimagewriter
          kdePackages.kdf
          kdePackages.kcron
          kdePackages.ksystemlog
          kdePackages.kjournald
          kdePackages.kbackup
          kdePackages.kup
          kdePackages.kleopatra
          kdePackages.yakuake

          wayland-utils
          wl-clipboard
          flatpak-xdg-utils
        ];
      };
      utilities = {
        description = "Install KDE utilities, accessibility, PIM and network applications";
        packages = with pkgs.kdePackages; [
          kcalc
          kcharselect
          kclock
          kcolorchooser
          kolourpaint
          kfind
          kalarm
          klevernotes
          korganizer
          calligra
          # neochat # Unsafe due olm dependency

          kmag
          kmousetool
          kmouth

          kget
          krfb
          ktorrent
          konqueror
        ];
      };
      multimedia = {
        description = "Install KDE multimedia, scanning and optical media applications";
        packages = with pkgs.kdePackages; [
          dragon
          kamoso
          krecorder
          kwave
          kmix
          koko
          kimageannotator
          skanpage
          k3b
          audex
          audiocd-kio
        ];
      };
      education = {
        description = "Install KDE education and science applications";
        packages = with pkgs.kdePackages; [
          # itinerary # Unsafe due olm dependency
          step
          kig
          kgeography
          klettres
          kbruch
          kalk
          kalgebra
          cantor
          artikulate
          marble
          kwordquiz
          blinken
        ];
      };
      games = {
        description = "Install KDE games";
        packages = with pkgs.kdePackages; [
          kblackbox
          kblocks
          kbreakout
          kigo
          kmahjongg
          kmines
          kollision
          kpat
          ksudoku
          ktuberling
          skladnik
          picmi
          palapeli
          lskat
          kubrick
          kdiamond
          ksirk
          klickety
          klines
          granatier
        ];
      };
      development = {
        description = "Install KDE development tools (KDevelop, Umbrello, Lokalize…)";
        packages = with pkgs; [
          kdePackages.kdevelop
          kdePackages.umbrello
          kdePackages.massif-visualizer
          kdePackages.lokalize
          kdiff3
        ];
      };
    };
  };
in
{
  options.myConfig.gui.plasma = generated.options;

  config = lib.mkIf (cfg.desktop == "plasma") (
    lib.mkMerge [
      generated.config
      {
        # Greeter state (last user and session).
        myConfig.system.impermanence.persistDirectories = [
          {
            directory = "/var/lib/plasmalogin";
            user = "plasmalogin";
            group = "plasmalogin";
            mode = "0750";
          }
        ];

        services = {
          desktopManager.plasma6 = {
            enable = true;
            enableQt5Integration = true;
          };

          displayManager.plasma-login-manager.enable = true;

          xserver.enable = true;
        };

        # Installs KDE Connect and opens its TCP/UDP 1714-1764 range.
        programs.kdeconnect.enable = cfg.plasma.integration;
      }
    ]
  );
}
