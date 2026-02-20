# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, pkgs, vars, ... }:

{
  home.username = "bensuperpc";
  home.homeDirectory = "/home/bensuperpc";
  programs.home-manager.enable = true;
  home.packages = with pkgs; [
  ];

  home.file = {
    "Repository/work/.keep".text = "";
    "Repository/personal/.keep".text = "";
    "Repository/opensource/.keep".text = "";
  };

  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = "$HOME/Templates";
  };

  programs.plasma = {
    enable = true;
    # Override config each update
    overrideConfig = true;
    # Override config each reboot
    immutableByDefault = true;

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
                "applications:org.kde.konsole.desktop"
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.discover.desktop"
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
  
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Bensuperpc";
        email = "bensuperpc@example.com";
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -l";
      ".." = "cd ..";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" "sudo" ];
    };

    history = {
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
    };
  };
  

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;

      format = ''
  [░▒▓](#9A348E)$os$username$hostname[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#86BBD8)$c$elixir$elm$golang$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$nix_shell[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)
  $character'';

      os = {
        disabled = false;
        style = "bg:#9A348E fg:white";
        symbols.NixOS = " ";
      };

      username = {
        show_always = true;
        style_user = "bg:#9A348E fg:white";
        style_root = "bg:#9A348E fg:red";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "bg:#9A348E fg:white";
        format = "[@$hostname]($style)";
      };

      directory = {
        style = "bg:#DA627D fg:white";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:#FCA17D fg:black";
        format = "[[ $symbol $branch ]($style)]";
      };

      git_status = {
        style = "bg:#FCA17D fg:black";
        format = "[[($all_status$ahead_behind )]($style)]";
      };

      nix_shell = {
        symbol = "";
        style = "bg:#06969A fg:white";
        format = "[ $symbol $state]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#33658A fg:white";
        format = "[ $time ]($style)";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  # Installed version of Home Manager, don't update this value after the first installation
  home.stateVersion = "25.11";
}