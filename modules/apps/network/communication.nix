{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.communication;

  basePackages = with pkgs; [ ];

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
    chat = moduleHelpers.mkEnabledOption "Install chat and team communication applications";
    voice = moduleHelpers.mkEnabledOption "Install voice communication applications";
    mail = moduleHelpers.mkEnabledOption "Install email clients";
    terminal = moduleHelpers.mkEnabledOption "Install terminal communication tools";
  };

  config = lib.mkMerge [
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}

