# More info: https://nix-community.github.io/plasma-manager/options.xhtml
{ config, pkgs, pkgs-stable, pkgs-master, pkgs-unstable, vars, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    shellAliases = {
      ll = "ls -lah";
      ".." = "cd ..";
      "dl-audio" = "yt-dlp -f bestaudio --extract-audio --embed-thumbnail --embed-metadata --embed-chapters --output \"%\(title)s.%\(ext)s\"";
      "dl-video" = "yt-dlp -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/bestvideo+bestaudio --embed-thumbnail --embed-metadata --embed-chapters --output \"%\(title)s.%\(ext)s\"";
      "git-log" = "git log --oneline --decorate --graph";
    };

    oh-my-zsh = {
      enable = true;
      plugins = [ 
        "git"
        "docker"
        "docker-compose"
        "sudo"
        "command-not-found"
        "history"
#        "zsh-autosuggestions"
#        "zsh-syntax-highlighting"
        "z"
        ];
    };

    history = {
      size = 1000000;
      path = "${config.xdg.dataHome}/zsh/history";
      extended = true;
      ignoreDups = true;
      ignoreSpace = true;
    };
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      add_newline = false;

      format = ''
  [░▒▓](#9A348E)$os$username$hostname[](bg:#DA627D fg:#9A348E)$directory[](fg:#DA627D bg:#FCA17D)$git_branch$git_status[](fg:#FCA17D bg:#86BBD8)$c$elixir$elm$golang$haskell$java$julia$nodejs$nim$rust$scala[](fg:#86BBD8 bg:#06969A)$nix_shell[](fg:#06969A bg:#33658A)$time[ ](fg:#33658A)
  $character'';

      os = {
        disabled = false;
        style = "bg:#9A348E fg:white";
        symbols.NixOS = " ";
      };

      username = {
        show_always = true;
        style_user = "bg:#9A348E fg:white";
        style_root = "bg:#9A348E fg:red";
        format = "[$user]($style)";
      };

      hostname = {
        ssh_only = false;
        style = "bg:#9A348E fg:white";
        format = "[@$hostname]($style)";
      };

      directory = {
        style = "bg:#DA627D fg:white";
        format = "[ $path ]($style)";
        truncation_length = 3;
        truncation_symbol = "…/";
      };

      git_branch = {
        symbol = "";
        style = "bg:#FCA17D fg:black";
        format = "[[ $symbol $branch ]($style)]";
      };

      git_status = {
        style = "bg:#FCA17D fg:black";
        format = "[[($all_status$ahead_behind )]($style)]";
      };

      nix_shell = {
        symbol = "";
        style = "bg:#06969A fg:white";
        format = "[ $symbol $state]($style)";
      };

      time = {
        disabled = false;
        time_format = "%R";
        style = "bg:#33658A fg:white";
        format = "[ $time ]($style)";
      };

      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
}