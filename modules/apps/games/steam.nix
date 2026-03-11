{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    protonup-qt
    wineWow64Packages.waylandFull
    vkd3d
    #vkd3d-proton
  ];

  programs.steam = {
    enable = true;
    protontricks.enable = true;
    # dedicatedServer.openFirewall = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extraPackages = with pkgs; [
      steam-run
      proton-ge-bin
    ];
  };
}