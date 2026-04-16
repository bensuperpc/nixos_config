{
  name = "bensuperpc";
  user = "bensuperpc";
  fullName = "Bensuperpc";
  email = "bensuperpc@gmail.com";
  sshPubKeyAccess = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJKqFkmpBOBocT1zns352C/ud0V+FdRVGzZeg1xb9S9" ];
  mainSshKeyName = "id_ed25519_2026";

  # Shell package name (must be a top-level attribute of pkgs, e.g. "zsh", "bash", "fish")
  shell = "zsh";

  # System groups this user belongs to
  extraGroups = [
    "networkmanager"
    "wheel"
    "render"
    "audio"
    "video"
    "input"
    "docker"
    "libvirtd"
  ];

  # Changed on first login via `passwd`
  initialPassword = "changeme";

  # Must match system.stateVersion in configuration.nix
  homeStateVersion = "25.11";
}