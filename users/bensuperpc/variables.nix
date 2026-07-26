{
  name = "bensuperpc";
  user = "bensuperpc";
  fullName = "Bensuperpc";
  email = "bensuperpc@gmail.com";
  sshPubKeyAccess = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGJKqFkmpBOBocT1zns352C/ud0V+FdRVGzZeg1xb9S9"
  ];

  localSSHKeyName = "id_ed25519_local_2026";

  githubSSHKeyName = "id_ed25519_github_2026";
  gitlabSSHKeyName = "id_ed25519_gitlab_2026";
  codebergSSHKeyName = "id_ed25519_codeberg_2026";
  forgejoSSHKeyName = "id_ed25519_forgejo_2026";
  defaultOnlineSSHKeyName = "id_ed25519_github_2026";

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
}
