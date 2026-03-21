# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, osConfig, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

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

        # Floating panel like macOS dock
        lengthMode = "fill";
        floating = false;

        widgets = [
          {
            kickoff = {
              sortAlphabetically = true;
              icon = "start-here-kde-symbolic";
            };
          }
          "org.kde.plasma.pager"
          {
            iconTasks = {
              launchers =
                [
                ]
                ++ lib.optionals osConfig.myConfig.apps.browser.core [
                  "applications:torbrowser.desktop"
                  "applications:firefox.desktop"
                ]
                ++ [
                  "applications:org.kde.konsole.desktop"
                  "applications:org.kde.dolphin.desktop"
                ]
                ++ lib.optionals osConfig.myConfig.apps.games.steam.client [
                  "applications:steam.desktop"
                ];
            };
          }
          "org.kde.plasma.panelspacer"
          {
            systemTray.items = {
              shown = [
                "org.kde.plasma.networkmanagement"
                "org.kde.plasma.volume"
                "org.kde.plasma.virtualkeyboard"
                "org.kde.plasma.notifications"
                "org.kde.plasma.clipboard"
                "org.kde.plasma.brightness"
                "org.kde.plasma.devicenotifier"
              ];
              hidden = [
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
          "org.kde.plasma.showdesktop"
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