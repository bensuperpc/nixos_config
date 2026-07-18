{ config, lib, pkgs, ... }:

{
  security.rtkit.enable = true;
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
    jack.enable = true;
    #media-session.enable = true;
  };
}
