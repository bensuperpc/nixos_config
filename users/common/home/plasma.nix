# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, vars, ... }:

{
  programs.plasma = {
    enable = true;
    overrideConfig = true;
    immutableByDefault = false;

    input.keyboard = {
      numlockOnStartup = "on";
    };

    workspace = {
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
      iconTheme = "breeze-dark";
      cursor.theme = "breeze_cursors";
    };

    panels = [
      {
        location = "bottom";
        height = 44;
        # hiding = "dodgewindows";
        floating = false;
        lengthMode = "fit";
        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "start-here-kde-symbolic";
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:firefox.desktop"
                "applications:torbrowser.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:steam.desktop"
              ];
            };
          }
          "org.kde.plasma.panelspacer"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.systray"
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.virtualkeyboard"
                "org.kde.plasma.notifications"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.brightness"
                "org.kde.plasma.devicenotifier"
                "org.kde.plasma.marginsseparator"
                "org.kde.plasma.digitalclock"
                "org.kde.plasma.showdesktop"
              ];
              hidden = [
                "org.kde.plasma.battery"
                "org.kde.plasma.bluetooth"
              ];
              configs.battery.showPercentage = true;
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "monday";
              date.enable = true;
              time.format = "24h";
            };
          }
        ];
      }
    ];

    hotkeys.commands = {
      launch-steam = {
        name = "Launch Steam";
        key = "Meta+Shift+S";
        command = "steam";
      };
    };
    session = {
      general.askForConfirmationOnLogout = true;
      sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";
    };
    kscreenlocker = {
      autoLock = true;
      passwordRequired = true;
      # lockOnResume = true;
      # lockOnStartup = true;
      timeout = 30;
      passwordRequiredDelay = 300;
      appearance = {
        alwaysShowClock = true;
        showMediaControls = false;
      };
    };
    powerdevil = {
      AC = {
        powerButtonAction = "showLogoutScreen";
        autoSuspend = {
          action = "sleep";
          idleTimeout = 10000;
        };
        dimDisplay = {
          idleTimeout = 1500;
        };
        turnOffDisplay = {
          idleTimeout = 3000;
          idleTimeoutWhenLocked = 450;
        };
        powerProfile = "balanced";
      };
      battery = {
        powerButtonAction = "lockScreen";
        powerProfile = "powerSaving";
      };
      lowBattery = {
        whenLaptopLidClosed = "sleep";
        powerProfile = "powerSaving";
      };
      batteryLevels = {
        lowLevel = 20;
        criticalLevel = 3;
      };
    };

    configFile = {
      baloofilerc."Basic Settings"."Indexing-Enabled" = false;
    };
  };
}