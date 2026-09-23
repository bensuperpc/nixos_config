{
  pkgs,
  ...
}:
let
  toolsPackages = with pkgs; [
    wget
    curl
    tree
    parallel
    cryptsetup
    coreutils-full
    rsync
    zstd
    btop
    xdelta
    xz
    tmux
    fastfetch # System information tool
    fio # Benchmarking tool for storage devices
    yazi # CLI file manager
    fff
  ];

  nixToolsPackages = with pkgs; [
    nix-du
    nix-fast-build
  ];
in
{
  environment.systemPackages = toolsPackages ++ nixToolsPackages;

  programs = {
    nix-ld.enable = true;

    nh = {
      enable = true;
      flake = "github:bensuperpc/nixos_config";
    };

    yazi.enable = true;
    nix-index-database.comma.enable = true;
  };
}
