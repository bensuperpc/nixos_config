{ config, pkgs, inputs, vars, ... }:

{
  users.users.bensuperpc = {
    isNormalUser = true;
    description = "Bensuperpc";
    extraGroups = [ "networkmanager" "wheel" "docker" "render" "audio"
                    "input" "docker" "networkmanager" "systemd-journal" "video" ];
    openssh.authorizedKeys.keys = [
      vars.gitKey
    ];
    shell = pkgs.zsh;
    
    # packages = with pkgs; [
    # ];
  };
  security.sudo.extraRules = [
    {
    users = [ "bensuperpc" ];
    commands = [
      { command = "ALL"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.systemd}/bin/poweroff"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.systemd}/bin/reboot"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  home-manager.users.bensuperpc = {
    imports = [ ./home.nix ];
    
    home.stateVersion = "25.11";
  };
}