{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.myConfig.gui;
in
{
  config = lib.mkIf (cfg.desktop == "plasma") {
    # When booting the system without a monitor and then connecting a monitor, the login screen will not show up.
    systemd.services.plasmalogin-hotplug-fix = {
      description = "Restart the Plasma login greeter after a display is hotplugged";
      serviceConfig.Type = "oneshot";
      startLimitIntervalSec = 0;
      path = [
        pkgs.systemd
        pkgs.gawk
        pkgs.util-linux
      ];
      script = ''
        exec 200>/run/plasmalogin-hotplug-fix.lock
        flock -n 200 || exit 0
        sleep 1

        for session in $(loginctl list-sessions --no-legend | awk '{print $1}'); do
          class=$(loginctl show-session "$session" -p Class --value)
          seat=$(loginctl show-session "$session" -p Seat --value)
          if [ "$class" = "user" ] && [ -n "$seat" ]; then
            echo "A graphical session is active on seat '$seat', skipping greeter restart."
            exit 0
          fi
        done

        systemctl -M plasmalogin@ --user restart plasma-login-wayland.target
      '';
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="drm", ACTION=="change", TAG+="systemd", ENV{SYSTEMD_WANTS}+="plasmalogin-hotplug-fix.service"
    '';
  };
}
