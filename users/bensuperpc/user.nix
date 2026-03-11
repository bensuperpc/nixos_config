{ config, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  users.groups.${vars.admin.user} = {
    members = [
    ];
  };

  users.users.${vars.admin.user} = {
    isNormalUser = true;
    description = "${vars.admin.fullName}";
    initialPassword = "";
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
    openssh.authorizedKeys.keys = [
      vars.admin.publicKey
    ];
    shell = pkgs.zsh;
    
    # packages = with pkgs; [
    # ];
  };
  security.sudo.extraRules = [
    {
    users = [ "${vars.admin.user}" ];
    commands = [
      { command = "ALL"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.systemd}/bin/poweroff"; options = [ "NOPASSWD" ]; }
      { command = "${pkgs.systemd}/bin/reboot"; options = [ "NOPASSWD" ]; }
      ];
    }
  ];

  home-manager = {
    users.${vars.admin.user} = {
      imports = [ ./home.nix ];
      home.stateVersion = "25.11";
    };
  };
}