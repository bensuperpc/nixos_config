{ pkgs, pkgs-stable, pkgs-master, pkgs-unstable, inputs, vars, ... }:

{
  environment.systemPackages = with pkgs; [
    # System tools
    btop
    htop
    bottom
    # network tools
    wget
    curl
    # CLI tools
    fastfetch
    dos2unix
    fdupes
    flex
    tree
    fmt
    fd
    git
    jq
    tmux
    localsend
    ripgrep
    parallel
    onboard
    perf
    fzf
    binutils
    help2man
    ripgrep-all
    jp2a
    internetarchive
    # AV
    clamtk
    # Communication tools
    discord
    mumble
    # telegram-desktop
    thunderbird
    cryptsetup
    lm_sensors
    wireshark
    # Wikipedia
    kiwix
    llmfit
  ];
  #programs.dconf.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}