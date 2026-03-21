# profiles/all.nix
{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:
{
  imports = [
    ./multimedia-createur.nix
    ../tests/check-docker.nix
    ../tests/check-dev.nix
    ../tests/check-browser.nix
    ../tests/check-game.nix
    ../tests/check-files.nix
    ../tests/check-productivity.nix
    ../tests/check-terminal.nix
    ../tests/check-math.nix
    ../tests/check-torrent.nix
  ];

  myConfig.apps.games.enableAll = true;
  myConfig.apps.development.enableAll = true;
  
  myConfig.apps.office = {
    suite = true;
    writing = true;
    notes = true;
  };
  myConfig.apps.electronic = {
    design = true;
    diagnostics = true;
  };
  myConfig.apps.docker.engine = true;
  myConfig.apps.math = {
    geometry = true;
    plotting = true;
  };


  myConfig.apps.torrent = {
    qbittorrent = true;
    transmission = true;
    helpers = true;
    openFirewall = true;
  };

  myConfig.apps.flashing.tools = true;
  myConfig.apps.browser = {
    core = true;
    extra = true;
  };
  myConfig.apps.kvm.host = true;

  myConfig.apps.communication = {
    chat = true;
    voice = true;
    mail = true;
    terminal = true;
  };
  myConfig.apps.files.enableAll = true;
  myConfig.apps.antivirus.scanner = true;
  myConfig.apps.powerManagement.services = true;

  myConfig.apps.hardwareGuiTools.tools = true;
  myConfig.apps.hardwareCliTools.tools = true;
  
  myConfig.apps.printing.service = true;
  myConfig.apps.printing3d.tools = true;

  myConfig.apps.additionalFonts.nerdFonts = true;

  boot.kernelPackages = lib.mkForce pkgs.linuxPackages_zen;
}