{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

let
  cfg = config.myConfig.apps.games.emulator;

  basePackages = with pkgs; [
  ];

  nintendoPackages = with pkgs; [
    dolphin-emu # Nintendo GameCube/Wii
    simple64 # Nintendo 64
    mupen64plus # Nintendo 64
    n64recomp # Nintendo 64
    snes9x # Super Nintendo Entertainment System
    zsnes2 # Super Nintendo Entertainment System
    bsnes-hd # Super Nintendo Entertainment System
    mgba # Game Boy Advance
    sameboy # Game Boy
    azahar
  ];
  segaPackages = with pkgs; [
    kega-fusion # Sega Genesis/Mega Drive, Sega CD, 32X
    # yabause # Sega Saturn
  ];
  sonyPackages = with pkgs; [
    ppsspp-sdl-wayland
    pcsx2 # PlayStation 2
    rpcs3 # PlayStation 3
  ];
  retroPackages = with pkgs; [
    atari800 # Atari 5200
    hatari # Atari ST/STE/TT/Falcon
    stella # Atari 2600 VCS
    ares
    fuse-emulator
  ];
  xboxPackages = with pkgs; [
    xemu # Xbox
    xenia-canary # Xbox 360
  ];
  experimentalPackages = with pkgs; [
    eden
  ];

  enabledOptionalsPackages =
      lib.optionals cfg.nintendo nintendoPackages
      ++ lib.optionals cfg.sony sonyPackages
      ++ lib.optionals cfg.retro retroPackages
      ++ lib.optionals cfg.xbox xboxPackages
      ++ lib.optionals cfg.sega segaPackages
      ++ lib.optionals cfg.experimental experimentalPackages;

    anyEnabled = lib.any (x: x) [
      cfg.nintendo
      cfg.sony
      cfg.retro
      cfg.xbox
      cfg.experimental
      cfg.sega
    ];
in
{
  options.myConfig.apps.games.emulator = {
    nintendo = moduleHelpers.mkEnabledOption "Install Nintendo family emulators";
    sony = moduleHelpers.mkEnabledOption "Install Sony family emulators";
    retro = moduleHelpers.mkEnabledOption "Install retro and multi-system emulators";
    xbox = moduleHelpers.mkEnabledOption "Install Xbox emulators";
    sega = moduleHelpers.mkEnabledOption "Install Sega family emulators";
    experimental = moduleHelpers.mkEnabledOption "Install experimental emulators";
  };

  config = lib.mkMerge [ 
    {
      environment.systemPackages = basePackages;
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
      hardware.graphics.enable = true;
    })
  ];
}
