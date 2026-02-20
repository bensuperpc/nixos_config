{ pkgs, inputs, vars, ... }:
{
  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
    docker-color-output
  ];

  virtualisation.docker = {
    enable = true;
    # If you use btrfs, you can set it as the storage driver.
    # storageDriver = "btrfs";
  };
}