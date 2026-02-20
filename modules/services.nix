{ pkgs, inputs, vars, ... }:

{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.flatpak.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "fr";
    variant = "";
  };

  services.logrotate.enable = true;

  # Configure console keymap
  console.keyMap = "fr";

  # Enable CUPS to print documents.
  services.printing = {
    enable = true;
    drivers = [
      # pkgs.nixpkgs-stable.hplip
      # pkgs.nixpkgs-stable.hplipWithPlugin
    ];
  };

  # Scanners
  #hardware.sane.enable = true;

  # Enable udisks2 for automounting and managing disks.
  services.udisks2.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  services.power-profiles-daemon.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      "192.168.1.0/8"
      "127.0.0.0/8"
    ];
    bantime = "24h";
    bantime-increment = {
      enable = true;
      #formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      multipliers = "1 2 4 8 16 32 64";
      maxtime = "168h";
      overalljails = true;
    };
    # jails = {
    #   apache-nohome-iptables.settings = {
    #     filter = "apache-nohome";
    #     action = ''iptables-multiport[name=HTTP, port="http,https"]'';
    #     logpath = "/var/log/httpd/error_log*";
    #     backend = "auto";
    #     findtime = 600;
    #     bantime  = 600;
    #     maxretry = 5;
    #   };
    # };
  };
}
