# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, lib, pkgs, ... }:

{
  xdg = {
    # KDE already have their own services
    #autostart.enable = true;
    
    # Same as default values
    # cacheHome = "${config.home.homeDirectory}/.cache";
    # configHome = "${config.home.homeDirectory}/.config";
    # dataHome = "${config.home.homeDirectory}/.local/share";
    # stateHome = "${config.home.homeDirectory}/.local/state";


    userDirs = {
      enable = true;
      createDirectories = true;
      setSessionVariables = true;

      desktop = "$HOME/Desktop";
      documents = "$HOME/Documents";
      download = "$HOME/Downloads";
      music = "$HOME/Music";
      pictures = "$HOME/Pictures";
      videos = "$HOME/Videos";
      templates = "$HOME/Templates";
    };

    configFile."mimeapps.list".force = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "application/pdf" = [ "org.kde.okular.desktop" ];
        "application/json" = [ "org.kde.kate.desktop" ];
        "text/html" = [ "org.kde.kate.desktop" ];
        "text/plain" = [ "org.kde.kate.desktop" ];
        # Image formats
        "image/png"         = [ "org.kde.gwenview.desktop" ];
        "image/jpeg"        = [ "org.kde.gwenview.desktop" ];
        "image/webp"        = [ "org.kde.gwenview.desktop" ];
        "image/gif"         = [ "org.kde.gwenview.desktop" ];
        "image/bmp"         = [ "org.kde.gwenview.desktop" ];
        "image/tiff"        = [ "org.kde.gwenview.desktop" ];
        "image/svg+xml"     = [ "org.kde.gwenview.desktop" ];
        "image/x-xbitmap"   = [ "org.kde.gwenview.desktop" ];
        "image/x-xpixmap"   = [ "org.kde.gwenview.desktop" ];
        # Video formats
        "video/mp4"         = [ "vlc.desktop" ];
        "video/x-matroska"  = [ "vlc.desktop" ];  # MKV
        "video/webm"        = [ "vlc.desktop" ];
        "video/x-msvideo"   = [ "vlc.desktop" ];  # AVI
        "video/quicktime"   = [ "vlc.desktop" ];  # MOV
        "video/x-ms-wmv"    = [ "vlc.desktop" ];
        "video/mpeg"        = [ "vlc.desktop" ];
        # Audio formats
        "audio/mpeg"        = [ "vlc.desktop" ];  # MP3
        "audio/flac"        = [ "vlc.desktop" ];
        "audio/ogg"         = [ "vlc.desktop" ];  # Opus, Vorbis, etc.
        "audio/wav"         = [ "vlc.desktop" ];
        "audio/x-wav"       = [ "vlc.desktop" ];
        "audio/aac"         = [ "vlc.desktop" ];
        "audio/mp4"         = [ "vlc.desktop" ];  # AAC dans MP4
        "audio/webm"        = [ "vlc.desktop" ];
        # URL handlers
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "inode/directory" = [ "org.kde.dolphin.desktop" ];
        # https://github.com/microsoft/vscode/issues/146408
        "x-scheme-handler/vscode" = [ "code-url-handler.desktop" ];
      };
      associations.removed = {
      };
      associations.added = {
      };
    };
  };
}