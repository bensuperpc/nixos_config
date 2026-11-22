{
  config,
  lib,
  moduleHelpers,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.system.audio;
in
{
  options.myConfig.system.audio = {
    enable = moduleHelpers.mkEnabledOption "PipeWire audio stack (ALSA, PulseAudio, JACK)";
  };

  config = lib.mkIf cfg.enable {

    environment.systemPackages = with pkgs; [
      pipewire.jack
    ];
    security.rtkit.enable = true;
    services.pulseaudio.enable = false;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };
  };
}
