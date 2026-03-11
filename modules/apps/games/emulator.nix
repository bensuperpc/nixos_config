{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # NGC/Wii emulators
    dolphin-emu
    # N64 emulators
    simple64
    mupen64plus
    # SNES emulators
    snes9x
    zsnes2
    bsnes-hd
    # Ataris 8 bit
    atari800
    stella
    # NES emulators
    # fceux-qt6
    # PS1 emulators
    ppsspp-sdl-wayland
    # PS2 emulators
    pcsx2
    # GBA emulators
    mgba
    # Gameboy emulators
    sameboy
    # RetroArch and cores
    # retroarch-full
  ];
}