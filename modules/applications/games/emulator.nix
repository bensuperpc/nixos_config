{ config, lib, pkgs, moduleHelpers, ... }:

let
  cfg = config.myConfig.apps.games.emulator;

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
    azahar # 3DS
    ryubing # Switch 1 emulator
    eden # Switch 1 emulator
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

  enabledOptionalsPackages =
      lib.optionals cfg.nintendo nintendoPackages
      ++ lib.optionals cfg.sony sonyPackages
      ++ lib.optionals cfg.retro retroPackages
      ++ lib.optionals cfg.xbox xboxPackages
      ++ lib.optionals cfg.sega segaPackages;

    anyEnabled = lib.any (x: x) [
      cfg.nintendo
      cfg.sony
      cfg.retro
      cfg.xbox
      cfg.sega
    ];
in
{
  options.myConfig.apps.games.emulator = {
    nintendo = moduleHelpers.mkDisabledOption "Install Nintendo family emulators";
    sony = moduleHelpers.mkDisabledOption "Install Sony family emulators";
    retro = moduleHelpers.mkDisabledOption "Install retro and multi-system emulators";
    xbox = moduleHelpers.mkDisabledOption "Install Xbox emulators";
    sega = moduleHelpers.mkDisabledOption "Install Sega family emulators";
  };

  config = lib.mkMerge [ 
    {
    }
    (lib.mkIf anyEnabled {
      environment.systemPackages = enabledOptionalsPackages;
    })
  ];
}
