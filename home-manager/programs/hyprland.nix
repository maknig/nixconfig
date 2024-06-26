{ config, lib, pkgs, inputs, ... }:

with lib;
let
  startw = pkgs.writeScriptBin "startw"
    ''
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
      border-radius=4
    '';
  };

  programs.waybar = {
    enable = true;
    # systemd = {
    #   enable = false;
    #   target = "graphical-session.target";
    # };
    style = ''
        * {
          font-family: "Ubuntu Mono Nerd Font";
          font-size: 12pt;
          font-weight: bold;
          border-radius: 0px;
          transition-property: background-color;
          transition-duration: 0.5s;
        }
        @keyframes blink_red {
          to {
            background-color: rgb(242, 143, 173);
            color: rgb(26, 24, 38);
          }
        }
        .warning, .critical, .urgent {
          animation-name: blink_red;
          animation-duration: 1s;
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }
        window#waybar {
          background-color: transparent;
        }
        window > box {
          margin-left: 5px;
          margin-right: 5px;
          margin-top: 5px;
          background-color: #3b4252;
        }
        *{
         padding:0px;
         margin:0px; 
         min-height: 15px;
         }
      #workspaces {
              padding-left: 0px;
              padding-right: 4px;
            }
      #workspaces button {
              padding-top: 0px;
              padding-bottom: 0px;
              padding-left: 6px;
              padding-right: 6px;
              color:#D8DEE9;
            }
      #workspaces button.active {
              background-color: rgb(181, 232, 224);
              color: rgb(26, 24, 38);
            }
      #workspaces button.urgent {
              color: rgb(26, 24, 38);
            }
      #workspaces button:hover {
              background-color: #B38DAC;
              color: rgb(26, 24, 38);
            }
            tooltip {
              /* background: rgb(250, 244, 252); */
              background: #3b4253;
            }
            tooltip label {
              color: #E4E8EF;
            }
      #mode, #clock,#battery, #memory, #temperature, #cpu, #mpd, #temperature, #backlight, #pulseaudio, #network {
              padding-left: 10px;
              padding-right: 10px;
            }
      #memory {

              color: #8EBBBA;
            }
      #custom-vpn {
              color: #8EBBBA;
            }
      #cpu {
              color: #B38DAC;
            }
      #clock {
              color: #E4E8EF;
            }
      #temperature {
              color: #80A0C0;
            }
      #battery{
              color: #80A0C0;
              min-width: 50px;
            }
      #language{
              color: #80A0C0;
            }


      #backlight {
              color: #A2BD8B;
            }

      #pulseaudio {
              color: #E9C98A;
            }
      #network {
              color: #99CC99;
            }

      #network.disconnected {
              color: #CCCCCC;
            }
      #tray {
              padding-right: 8px;
              padding-left: 10px;
            }
      #tray menu {
              background: #3b4252;
              color: #DEE2EA;
      }
      #mpd.paused {
              color: rgb(192, 202, 245);
              font-style: italic;
            }
      #mpd.stopped {
              background: transparent;
            }
      #mpd {
                color: #E4E8EF;
            }
    '';
    settings = [{
      "layer" = "top";
      "position" = "top";

      modules-left = [
        "hyprland/workspaces"
        "mpd"
      ];
      modules-center = [
      ];
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
        "clock"
        "tray"

      ];
      "hyprland/language" = {
        "format" = "{short}";
      };

      "backlight" = {
        "device" = "intel_backlight";
        "format" = "{percent}% {icon}";
        "format-icons" = [ "" "" ];
      };

      "custom/vpn" = {
        "interval" = 30;
        "format" = "{}";
        "exec" = "vpn_status";
      };
      "battery" = {
        "bat" = "BAT0";
        "interval" = 60;
        "states" = {
          "warning" = 30;
          "critical" = 15;
        };
        "format" = "{capacity}% {icon}";
        "format-icons" = [ "" "" "" "" "" ];
        "max-length" = 50;
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
        "on-click" = "pamixer -t";
        "tooltip" = false;
      };

      "clock" = {
        "interval" = 1;
        "format" = "{:%I:%M %p}";
        "tooltip" = true;
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

  home.file.".config/hypr/hyprpaper.conf".source = ./hyprland/hyprpaper.conf;
  home.file.".config/hypr/hyprlock.conf".source = ./hyprland/hyprlock.conf;
  home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;
}
