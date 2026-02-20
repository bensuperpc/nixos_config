{ pkgs, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # Minecraft launchers and tools
    prismlauncher
    jre8
    jre17_minimal
    jre21_minimal
    jre25_minimal
    mcaselector
    # Game launchers
    heroic
    # NGC/Wii emulators
    dolphin-emu
    # N64 emulators
    simple64
    # SNES emulators
    snes9x
    zsnes2
    bsnes-hd
    # NES emulators
    # fceux-qt6
    # PS1 emulators
    ppsspp-sdl-wayland
    # PS2 emulators
    pcsx2
    # GBA emulators
    mgba
    # RetroArch and cores
    # retroarch-full
    # Compatibility layers
    protonup-qt
    wineWowPackages.wayland
  ];

  programs.steam = {
    enable = true;
     extraPackages = with pkgs; [
      steam-run
    ];
  };
}