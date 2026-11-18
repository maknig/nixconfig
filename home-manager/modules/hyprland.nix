{ config
, lib
, pkgs
, inputs
, ...
}:
with lib; let

  cfg = config.dots.profiles.hyprland;

  powermenu =
    pkgs.writeScriptBin "powermenu"
      ''
        #entries="⇠\tLogout\n⏾\tSuspend\n⭮\tReboot\n⏻\tShutdown"
        entries="\n⇠\n⏾\n⭮\n⏻"

        selected=$(echo -e $entries | rofi -dmenu -i -theme $HOME/.config/rofi/powermenu.rasi)

        case $selected in
          )
          hyprlock
          ;;
          ⇠)
          hyprctl dispatch exit
          ;;
          ⏾)
          exec systemctl suspend
          ;;
          ⭮)
          exec systemctl reboot
          ;;
          ⏻)
          exec systemctl poweroff
          ;;
        esac
      '';

in
{
  options.dots.profiles.hyprland = {
    enable = mkEnableOption "enable hyprland";

  };
  config = mkIf cfg.enable {
    home.packages = [
      #inputs.hypr-contrib.packages.${pkgs.stdenv.hostPlatform.system}.grimblast
      pkgs.hyprpaper
      pkgs.hyprlock
      pkgs.hypridle
      pkgs.hyprshot
      pkgs.cliphist
      pkgs.wl-clipboard
      pkgs.rofi
      pkgs.waybar-mpris
      powermenu
      # pkgs.swaylock-effects
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

    #nixpkgs.overlays = [
    #  (final: prev: {
    #    waybar = prev.waybar.overrideAttrs (oldAttrs: {
    #      mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
    #    });
    #  })
    #];

    services.mpd = {
      enable = true;
      musicDirectory = "/home/matthias/Music";
      #user = "matthias";
      extraConfig = ''
        audio_output {
          type "pipewire"
          name "My PipeWire Output"
        }
      '';
    };

    services.mako = {
      enable = false;
      settings = {
        ignore-timeout = "true";
        default-timeout = 0;
        sort = "-time";
        max-history = 5;
        border-radius = 4;
        layer = "overlay";
        background-color = "#666666";
        border-color = "#1a1a1a";
        height = "100";
        width = "300";
        icons = "true";
        font = "UbuntuMono Nerd Font Light 12";
      };
    };

    programs.ashell = {
      enable = true;
      # Automatically starts ashell with your graphical session
      systemd.enable = false;

      package = pkgs.ashell.overrideAttrs (old: rec {
        version = "0.11.0-unstable-2026-11-10";
        src = pkgs.fetchFromGitHub {
          owner = "MalpenZibo";
          repo = "ashell";
          rev = "6de2268557e4aac838f9431475e875c5add44634";
          hash = "sha256-FZoapghA4ZtbYeHs5Yxc2FWWoorPH6IjOD8wXosZHbA=";
        };
        cargoDeps = pkgs.rustPlatform.fetchCargoVendor {
          inherit src;
          hash = "sha256-tq0sQ9nRzKRTDVR6BUJNUAJK+n9UzHJiCAkGtKwVLUI=";
        };
      });

      # Translates Nix attributes directly into config.toml
      settings = {
        language = "en-US"; # UI language
        region = "de-CH";
        modules = {
          left = [ "Workspaces" "MediaPlayer" ];
          center = [ "WindowTitle" ];
          right = [
            "SystemInfo"
            [ "Privacy" "Settings" ]
            "KeyboardLayout"
            "Tempo"
            "Notifications"
            "Tray"
          ];
        };
        keyboard_layout = {
          labels = {
            "English (US)" = "EN";
            "German (Switzerland)" = "CH";
          }; # (default: {}) map layout names to short labels
        };

        appearance = {
          success_color = "#a3be8c";
          warning_color = "#ebcb8b";
          danger_color = "#bf616a";
          text_color = "#eceff4";
          workspace_colors = [ "#88c0d0" "#81a1c1" "#5e81ac" ];

          primary_color = {
            base = "#88c0d0";
            text = "#242933";
          };

          background_color = {
            base = "#3b4252";
            weak = "#434c5e";
            strong = "#4c566a";
          };
          #font_name = "Ubuntu Mono Nerd Font";
          #background_color = "#000000";
          #text_color = "#F2E9E4";
          #primary_color = { base = "#caccd1"; text = "#383c4a"; };
          #success_color = "#a6da95";
          #warning_color = "#eed49f";
          #danger_color = "#ed8796";
          #opacity = { default = 1.0; bar = 0.65; };

          bar = {
            surface = "solid";
            radius = "sm";
            margin = [ 5 5 0 5 ];
            padding = 0;
          };



          modules = {
            default.radius = "sm";
            group.radius = "sm";
            workspaces.radius = "sm";
          };
        };
        workspaces = {
          visibility_mode = "MonitorSpecific";
        };
      };
    };

    programs.waybar = {
      enable = true;
      systemd = {
        enable = false;
        targets = [ "graphical-session.target" ];
      };
      settings = [
        {
          "layer" = "top";
          "position" = "top";
          "spacing" = 0;

          modules-left = [
            "hyprland/workspaces"
            "mpris"
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
          "mpris" = {
            "format" = "{player_icon} {artist} - {title}";
            "format-paused" = "{status_icon} {artist} - {title}";
            "player-icons" = {
              "default" = "";
              "spotifyd" = "";
              "spotify" = "";
            };
            "status-icons" = {
              "paused" = "";
            };
            "ignored-players" = [ ]; #[ "firefox" ];
          };

          "backlight" = {
            "device" = "intel_backlight";
            "format" = "{icon}  {percent}%";
            "format-icons" = [ "" "" ];
          };

          "custom/vpn" = {
            "interval" = 30;
            "format" = "{} ";
            "format-icon" = [ "󱇱" "󱇱" ];
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
        }
      ];
    };


    home.file.".icons/default".source = "${pkgs.vanilla-dmz}/share/icons/Vanilla-DMZ";
    home.file.".config/waybar/style.css".source = ./waybar/style.css;
    home.file.".config/waybar/macchiato.css".source = ./waybar/macchiato.css;
    home.file.".config/hypr/hyprpaper.conf".source = ./hyprland/hyprpaper.conf;
    home.file.".config/hypr/hyprlock.conf".source = ./hyprland/hyprlock.conf;
    home.file.".config/hypr/hypridle.conf".source = ./hyprland/hypridle.conf;
    #home.file.".config/hypr/hyprland.conf".source = ./hyprland/hyprland.conf;

    home.file.".config/hypr/hyprland.lua".source = ./hyprland/hypr/hyprland.lua;
    home.file.".config/hypr/monitors.lua".source = ./hyprland/hypr/monitors.lua;
    home.file.".config/hypr/look.lua".source = ./hyprland/hypr/look.lua;
    home.file.".config/hypr/input.lua".source = ./hyprland/hypr/input.lua;
    home.file.".config/hypr/binds.lua".source = ./hyprland/hypr/binds.lua;
    home.file.".config/hypr/windowrules.lua".source = ./hyprland/hypr/windowrules.lua;

    home.file.".config/rofi/config.rasi".source = ./rofi/config.rasi;
    home.file.".config/rofi/powermenu.rasi".source = ./rofi/powermenu.rasi;
  };
}
