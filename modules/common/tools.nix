{
  pkgs,
  ...
}:
let
  toolsPackages = with pkgs; [
    wget
    tree
    parallel
    cryptsetup
    btop
    xdelta
    tmux
    fastfetch # System information tool
    fio # Benchmarking tool for storage devices
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
