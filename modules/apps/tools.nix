{ pkgs, inputs, vars, ... }:

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
    localsend
    ripgrep
    btrfs-snap
    btrfs-list
    btrfs-assistant
    adb-sync
    parallel
    onboard
    # Hardware tools
    pciutils
    usbutils
    # AV
    clamtk
    # Flashing tools
    qFlipper
    rpi-imager
    # Communication tools
    discord
    # telegram-desktop
    yt-dlp
    thunderbird
  ];

  programs.zsh.enable = true;
  programs.dconf.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}