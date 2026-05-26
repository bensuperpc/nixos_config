{ config, lib, pkgs, ... }:
{
  users = {
    defaultUserShell = pkgs.zsh;
    defaultUserHome = "/home";
  };
}