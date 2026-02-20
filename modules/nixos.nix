{ pkgs, inputs, vars, ... }:

{
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
  
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings = {
    download-buffer-size = 268435456;
    auto-optimise-store = true;
    max-jobs = 8;
  };

  nix.optimise.automatic = true;
  nix.optimise.dates = [ "12:00" ];

  zramSwap.enable = true;
}