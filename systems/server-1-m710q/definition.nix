{
  enabled = true;
  role = "full";
  system = "x86_64-linux";
  ip = "192.168.1.26";
  port = 22;

  # ssh-to-age of the host key, must match .sops.yaml (checked at evaluation time).
  ageRecipient = "age17ht0wefecdy2ef04e6gjr3zkakj8uzffx47q9dss2mnssurqn9pq02kjcf";

  users = [ "bensuperpc" ];
  deployUser = "bensuperpc";

  appProfiles = [ ];
  platformProfiles = [
    "platform/gpu-intel-skylake"
    "platform/cpu-intel"
    "platform/tpm"
    "platform/bluetooth"
    "platform/snapper"
    "platform/impermanence"
  ];
}
