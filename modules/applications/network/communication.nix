{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.communication;

  chatPackages = with pkgs; [
    discord
    telegram-desktop
    signal-desktop
    element-desktop
  ];

  voicePackages = with pkgs; [
    mumble
  ];

  mailPackages = with pkgs; [
    thunderbird
  ];

  terminalPackages = with pkgs; [
    sshx
    weechat
  ];

  enabledOptionalsPackages =
    lib.optionals cfg.chat chatPackages
    ++ lib.optionals cfg.voice voicePackages
    ++ lib.optionals cfg.mail mailPackages
    ++ lib.optionals cfg.terminal terminalPackages;

  anyEnabled = lib.any (x: x) [
    cfg.chat
    cfg.voice
    cfg.mail
    cfg.terminal
  ];
in
{
  options.myConfig.apps.communication = {
    chat = moduleHelpers.mkDisabledOption "Install chat and team communication applications";
    voice = moduleHelpers.mkDisabledOption "Install voice communication applications";
    mail = moduleHelpers.mkDisabledOption "Install email clients";
    terminal = moduleHelpers.mkDisabledOption "Install terminal communication tools";
  };

  config = lib.mkMerge [
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}

