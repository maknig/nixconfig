{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.dots.profiles.linux;

  vpn_status =
    pkgs.writeScriptBin "vpn_status"
      ''
        #!/usr/bin/env zsh
        set -eux -o pipefail

        if [ -d "/proc/sys/net/ipv4/conf/tun0" ]; then
            echo "󱇱"
        else
            echo ""
        fi
      '';
  susp =
    pkgs.writeScriptBin "susp"
      ''
        #!/usr/bin/env zsh
        hyprlock &
        systemctl suspend
      '';
in
{
  options.dots.profiles.linux = {
    enable = mkEnableOption "linux profile";
  };

  config = mkIf cfg.enable {
    home.packages = [
      susp
      vpn_status
      pkgs.firefox
      pkgs.papers
      pkgs.gthumb
      pkgs.networkmanager-openconnect
      pkgs.networkmanagerapplet
      #pkgs.openconnect_openssl
      pkgs.openconnect
      pkgs.libnotify
      pkgs.teams-for-linux
    ];

  };
}
