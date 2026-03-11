# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, vars, ... }:

{
  xdg.userDirs = {
    enable = true;
    createDirectories = true;

    desktop = "$HOME/Desktop";
    documents = "$HOME/Documents";
    download = "$HOME/Downloads";
    music = "$HOME/Music";
    pictures = "$HOME/Pictures";
    videos = "$HOME/Videos";
    templates = "$HOME/Templates";
  };

  xdg.configFile."mimeapps.list".force = true;
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "application/pdf" = [ "org.kde.okular.desktop" ];
      "application/json" = [ "org.kde.kate.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "text/html" = [ "org.kde.kate.desktop" ];
      "text/plain" = [ "org.kde.kate.desktop" ];
      "video/mp4" = [ "vlc.desktop" ];
      "video/mkv" = [ "vlc.desktop" ];
      "video/webm" = [ "vlc.desktop" ];
      "audio/x-opus+ogg" = [ "vlc.desktop" ];
      "audio/mpeg" = [ "vlc.desktop" ];
      "audio/flac" = [ "vlc.desktop" ];
      "x-scheme-handler/http" = [ "firefox.desktop" ];
      "x-scheme-handler/https" = [ "firefox.desktop" ];
      "inode/directory" = [ "org.kde.dolphin.desktop" ];
    };
    associations.removed = {
    };
    associations.added = {
    };
  };
}