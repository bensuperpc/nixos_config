{ config, lib, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, moduleHelpers, vars, ... }:

{
  imports = [
    ../common/system
  ];

  users.groups.${vars.admin.user} = {
    members = [
    ];
  };

  users.users.${vars.admin.user} = {
    isNormalUser = true;
    description = "${vars.admin.fullName}";
    initialHashedPassword = "admin";
    group = "${vars.admin.user}";
    extraGroups = [
      "networkmanager"
      "wheel"
      "render"
      "audio"
      "video"
      "input"
      "docker"
      # "systemd-journal"
      # "libvirt"
      "libvirtd"
      # "kvm"
    ];
    
    openssh.authorizedKeys.keys = vars.admin.sshPubKeyAccess;
    shell = pkgs.zsh;
    
    # packages = with pkgs; [
    # ];
  };
  security.sudo.extraRules = [
    {
    users = [ "${vars.admin.user}" ];
    commands = [
      { 
        command = "ALL"; options = [ "NOPASSWD" ]; 
      }
      { 
        command = "${pkgs.systemd}/bin/poweroff"; options = [ "NOPASSWD" ]; 
      }
      { 
        command = "${pkgs.systemd}/bin/reboot"; options = [ "NOPASSWD" ]; 
      }
      ];
    }
  ];

  home-manager = {
    users.${vars.admin.user} = {
      imports = [ ./home.nix ];
      # If update breaks, just create a new user
      home.stateVersion = "25.11";
    };
  };
}