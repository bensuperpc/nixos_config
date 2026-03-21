{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;
    defaultUserHome = "/home";
  };
}