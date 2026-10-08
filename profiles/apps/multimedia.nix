{ moduleHelpers, ... }:
{
  # Preset for content creation workloads.
  myConfig.apps.multimedia = moduleHelpers.mkDefaults {
    video = {
      editing = true;
      playback = true;
      codecs = true;
      opticalMedia = true;
      downloaders = true;
    };

    audio = {
      editing = true;
      conversion = true;
      library = true;
      playback = true;
    };

    image = {
      editing = true;
      graphing = true;
      management = true;
      formats = true;
      utilities = true;
      animation = true;
    };

    documents = {
      reading = true;
      pdf = true;
    };
  };
}
