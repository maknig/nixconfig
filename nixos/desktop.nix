{ config, lib, pkgs, inputs, ... }:

with lib;
let
  cfg = config.dots.profiles.desktop;

  wmList = [ "hyprland" "sway" ];
in
{
  options.dots.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
    wm = mkOption {
      description = "window manager";
      type = types.enum (wmList);
      default = "hyprland";
    };
  };

  config = mkIf cfg.enable {
    sound.enable = true;

    hardware = {
      pulseaudio = {
        enable = true;
        support32Bit = true;
        package = pkgs.pulseaudioFull;
      };
    };

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.gcr ];

    # hardware.bluetooth.enable = true;
    # services.blueman.enable = true;

    environment.systemPackages = with pkgs; [
      pamixer
      pulsemixer
    ] ++ lib.optionals (cfg.wm == "hyprland" || cfg.wm == "sway") [
      xdg-utils
      glib
      dracula-theme
      gnome3.adwaita-icon-theme
      mako
      wl-clipboard
      wlr-randr
      wayland
      wayland-scanner
      wayland-utils
      # egl-wayland
      wayland-protocols
    ];

    # fonts.fontconfig = {
    #   antialias = true;
    #
    #   # fixes antialiasing blur
    #   hinting = {
    #     enable = true;
    #     style = "slight"; # no difference
    #     autohint = true; # no difference
    #   };
    #
    #   subpixel = {
    #     rgba = "rgb";
    #     lcdfilter = "default";
    #   };
    # };

    hardware.opengl.enable = true;
    #hardware.nvidia.modesetting.enable = true;
    #hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;
    #hardware.nvidia.powerManagement.enable = true;


    # wayland and hyprland setup below

    programs.xwayland.enable = mkIf (cfg.wm == "hyprland" || cfg.wm == "sway") true;
    programs.hyprland =  {
      enable = true;
      #nvidiaPatches = true;
      xwayland.enable = true;
    };

    # FIXME use home-manager to use on Ubuntu?
    programs.sway = mkIf (cfg.wm == "sway") {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    # FIXME only for homemananger sway
    # security.polkit = mkIf (cfg.wm == "sway") {
    #   enable = true;
    # };

    xdg.portal = mkIf (cfg.wm == "hyprland" || cfg.wm == "sway") {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # gtkUsePortal = true;
    };

    security.pam.services = mkIf (cfg.wm == "hyprland" || cfg.wm == "sway") {
      swaylock = { };
    };

  };
}
