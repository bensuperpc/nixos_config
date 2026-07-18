{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.communication;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      chat = {
        description = "Install chat and team communication applications";
        packages = with pkgs; [ discord telegram-desktop signal-desktop element-desktop ];
      };
      voice = {
        description = "Install voice communication applications";
        packages = with pkgs; [ mumble ];
      };
      mail = {
        description = "Install email clients";
        packages = with pkgs; [ thunderbird ];
      };
      terminal = {
        description = "Install terminal communication tools";
        packages = with pkgs; [ sshx weechat ];
      };
    };
  };
in
{
  options.myConfig.apps.communication = generated.options;
  config = generated.config;
}
