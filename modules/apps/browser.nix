{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    tor-browser
    brave
    chromium
    firefox
    ladybird
    servo
  ];

  programs.firefox = {
    enable = true;
    policies = {
      DisableTelemetry = true;
      EnableTrackingProtection = {
          Value= true;
          Locked = true;
          Cryptomining = true;
          Fingerprinting = true;
      };
    };
  };
  programs.chromium = {
    homepageLocation = "";
    enable = true;
    extraOpts = {
	    "ExtensionManifestV2Availability" = 2;
    };
    extensions = [
    ];
  };
}