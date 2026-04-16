{ ... }:
{
  imports = [
    ./nixos
  ];

  # services.nix-serve = {
  #   enable = true;
  #   port = 5000;
  # };

  # nix.distributedBuilds = false;
  # nix.buildMachines = [
  #   {
  #     hostName = buildHost;
  #     system = "x86_64-linux";
  #     protocol = "ssh-ng";
  #     systems = ["x86_64-linux"];
  #     maxJobs = 16;
  #     speedFactor = 2;
  #     supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
  #     mandatoryFeatures = [ ];
  #   }
  # ];
}