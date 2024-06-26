{ config, lib, pkgs, inputs, ... }:

with lib;
let
  startw = pkgs.writeScriptBin "startw"
    ''
      export HYPRSHOT_DIR=~/Pictures/screenshots
      export XDG_SESSION_TYPE=wayland
      export WLR_NO_HARDWARE_CURSORS=1
      Hyprland
    '';
in
{
  home.packages = [
    inputs.hypr-contrib.packages.${pkgs.system}.grimblast
    pkgs.hyprpaper
    pkgs.hyprlock
    pkgs.hyprshot
    pkgs.rofi-wayland
    # pkgs.swaylock-effects
    startw
  ];

  services.wlsunset = {
    enable = true;
    latitude = "47.4";
    longitude = "8.5";
    temperature = {
      day = 5700;
      night = 3200;
    };
  };

  systemd.user.services.wlsunset.Install = { WantedBy = [ "graphical.target" ]; };

  nixpkgs.overlays = [
    (final: prev: {
      waybar = prev.waybar.overrideAttrs (oldAttrs: {
        mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
      });
    })
  ];


  services.mako = {
    enable = true;
    defaultTimeout = 0;
    ignoreTimeout = true;
    extraConfig = ''
      max-history=5
      sort=-time
      layer=overlay
      border-radius=4
      background-color=#666666
      border-color=#1a1a1a
      font=Cantarell Extra-Light 10
      default-timeout=0
    '';
  };

  programs.waybar = {
    enable = true;
    systemd = {
      enable = false;
      target = "graphical-session.target";
    };
    settings = [{
      "layer" = "top";
      "position" = "top";
      "spacing" = 0;

      modules-left = [
        "hyprland/workspaces"
        "mpd"
      ];
      modules-center = [ "clock" ];

      modules-right = [
        "custom/vpn"
        "pulseaudio"
        "battery"
        "backlight"
        "memory"
        "cpu"
        "temperature"
        "network"
        "hyprland/language"
        "tray"

      ];
      "hyprland/language" = {
        "format" = "{short}";
      };

      "backlight" = {
        "device" = "intel_backlight";
        "format" = "{icon}  {percent}%";
        "format-icons" = [ "" "" ];
      };

      "custom/vpn" = {
        "interval" = 30;
        "format" = "{}";
        "exec" = "vpn_status";
      };
      #"battery" = {
      #  "bat" = "BAT0";
      #  "interval" = 60;
      #  "states" = {
      #    "warning" = 30;
      #    "critical" = 15;
      #  };
      #  "format" = "{capacity}% {icon}";
      #  "format-icons" = [ "" "" "" "" "" ];
      #  "max-length" = 50;
      #};
      "battery" = {
        "states" = {
          "good" = 95;
          "warning" = 30;
          "critical" = 10;
        };
        "format" = "{icon} {capacity}%";
        "format-charging" = "{capacity}% ";
        "format-plugged" = "";
        "format-alt" = "{time} {icon}";
        "full-at" = 96;
        # "format-good": "", // An empty format will hide the module
        #"format-full": "",
        "format-icons" = [ "" "" "" "" "" ];
        "tooltip" = true;
        "tooltip-format" = "{timeTo}\nPWR:{power}W";
      };
      "upower" = {
        "show-icon" = false;
        "hide-if-empty" = true;
        "tooltip" = true;
        "tooltip-spacing" = 20;
      };

      "hyprland/workspaces" = {
        "format" = "{icon}";
        "on-click" = "activate";
      };

      "pulseaudio" = {
        "scroll-step" = 1;
        "format" = "{icon} {volume}%";
        "format-muted" = "󰖁 Muted";
        "format-icons" = {
          "default" = [ "" "" "" ];
        };
        "states" = {
          "warning" = 0;
        };
        "on-click" = "pavucontrol";
        "tooltip" = false;
      };

      #"clock" = {
      #  "interval" = 1;
      #  "format" = "{:%I:%M %p}";
      #  "tooltip" = true;
      #};
      "clock" = {
        # for a doc on how to format this =
        # https=#howardhinnant.github.io/date/date.html#to_stream_formatting
        # "timezone"= "America/New_York";
        # "tooltip-format"= "<tt><small>{calendar}</small></tt>";
        "tooltip-format" = "<tt>{calendar}</tt>";
        "format-alt" = "{:%Y-%m-%d}";
        "format" = "{:%a, %d %b, %H:%M %p}";
        "calendar" = {
          "mode" = "month";
          "mode-mon-col" = 3;
          "weeks-pos" = "left";
          "on-scroll" = 1;
          #   "on-click-right"= "mode";
          "format" = {
            #     "months"= "<span color='#ffead3'><b>{}</b></span>";
            #     "days"= "<span color='#ecc6d9'><b>{}</b></span>";
            "weeks" = "<span color='#99ffdd'><b>{}</b></span>";
            #     "weekdays"= "<span color='#ffcc66'><b>{}</b></span>";
            "today" = "<span color='#ff6699'><b><u>{}</u></b></span>";
          };
        };
        "actions" = {
          "on-scroll-up" = "shift_down";
          "on-scroll-down" = "shift_up";
        };
      };

      "memory" = {
        "interval" = 1;
        "format" = "󰍛 {percentage:2}%";
        "states" = {
          "warning" = 85;
        };
      };

      "cpu" = {
        "interval" = 1;
        "format" = "󰻠 {usage:2}%";
      };

      "mpd" = {
        "max-length" = 25;
        "format" = "<span foreground='#bb9af7'></span> {title}";
        "format-paused" = " {title}";
        "format-stopped" = "<span foreground='#bb9af7'></span>";
        "format-disconnected" = "";
        "on-click" = "mpc --quiet toggle";
        "on-click-right" = "mpc update; mpc ls | mpc add";
        "on-click-middle" = "kitty --class='ncmpcpp' ncmpcpp ";
        "on-scroll-up" = "mpc --quiet prev";
        "on-scroll-down" = "mpc --quiet next";
        "smooth-scrolling-threshold" = 5;
        "tooltip-format" = "{title} - {artist} ({elapsedTime:%M:%S}/{totalTime:%H:%M:%S})";
      };

      "network" = {
        "format-disconnected" = "󰯡 Disconnected";
        "format-ethernet" = "󰀂 {ifname} ({ipaddr})";
        "format-linked" = "󰖪 {essid} (No IP)";
        "format-wifi" = "󰖩 {essid}";
        "interval" = 1;
        "tooltip" = false;
      };

      "temperature" = {
        "tooltip" = false;
        "format" = " {temperatureC}°C";
      };

      "tray" = {
        "icon-size" = 13;
        "spacing" = 5;
      };
    }];
  };

  home.file.".config/waybar/style.css".source = ./waybar/style.css;
  home.file.".config/waybar/macchiato.css".source = ./waybar/macchiato.css;
  home.file.".config/hypr/hyprpaper.conf".source = ./hyprland/hyprpaper.conf;
  home.file.".config/hypr/hyprlock.conf".source = ./hyprland/hyprlock.conf;
  home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
}
