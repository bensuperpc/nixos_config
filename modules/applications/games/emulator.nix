{
  config,
  lib,
  pkgs,
  moduleHelpers,
  pkgsSets,
  ...
}:

let
  cfg = config.myConfig.apps.games.emulator;

  generated = moduleHelpers.mkPackageGroupModule {
    inherit cfg;
    groups = {
      nintendo = {
        description = "Install Nintendo family emulators";
        packages =
          with pkgs;
          [
            dolphin-emu # Nintendo GameCube/Wii
            simple64 # Nintendo 64
            mupen64plus # Nintendo 64
            n64recomp # Nintendo 64
            snes9x # Super Nintendo Entertainment System
            zsnes2 # Super Nintendo Entertainment System
            bsnes-hd # Super Nintendo Entertainment System
            mgba # Game Boy Advance
            sameboy # Game Boy
            melonds # Nintendo DS
            ryubing # Switch 1 emulator
            eden # Switch 1 emulator
            cemu # Wii U
          ]
          ++ (with pkgsSets.stable-2605; [
            azahar # 3DS
          ]);
      };
      sega = {
        description = "Install Sega family emulators";
        packages = with pkgs; [
          kega-fusion # Sega Genesis/Mega Drive, Sega CD, 32X
          # yabause # Sega Saturn
        ];
      };
      sony = {
        description = "Install Sony family emulators";
        packages =
          with pkgs;
          [
            ppsspp-sdl-wayland
          ]
          ++ (with pkgsSets.stable-2605; [
            # emulator.sony
            pcsx2 # PlayStation 2
            rpcs3 # PlayStation 3
          ]);
      };
      retro = {
        description = "Install retro and multi-system emulators";
        packages = with pkgs; [
          atari800 # Atari 5200
          hatari # Atari ST/STE/TT/Falcon
          stella # Atari 2600 VCS
          ares
          fuse-emulator
        ];
      };
      xbox = {
        description = "Install Xbox emulators";
        packages = with pkgs; [
          xemu # Xbox
          xenia-canary # Xbox 360
        ];
      };
    };
  };
in
{
  options.myConfig.apps.games.emulator = generated.options;
  inherit (generated) config;
}
