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

  #home.file.".config/hypr/hyprland.conf".source = ../modules/hyprland/hyprland.conf;
  config = mkIf cfg.enable {
    home.packages = [
      susp
      vpn_status
      pkgs.gthumb
      pkgs.networkmanager-openconnect
      pkgs.networkmanagerapplet
      pkgs.openconnect_openssl
      pkgs.libnotify
      pkgs.teams-for-linux
      pkgs.pavucontrol
      #pkgs.pamixer
    ];

  };
}
