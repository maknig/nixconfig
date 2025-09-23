{ config
, lib
, pkgs
, inputs
, ...
}:
with lib; let
  cfg = config.dots.profiles.desktop;

  stablePkgs = import inputs.nixpkgs-stable {
    inherit (pkgs) system;
    config.allowUnfree = true;
  };

in
{
  options.dots.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
  };

  config = mkIf cfg.enable {


    security.rtkit.enable = true;

    services.pulseaudio.enable = false;

    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      audio.enable = true;
      #package = stablePkgs.pipewire;
      #wireplumber.package = stablePkgs.wireplumber;
      package = pkgs.pipewire;
      wireplumber.package = pkgs.wireplumber;
    };



    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal pkgs.xdg-desktop-portal-wlr pkgs.xdg-desktop-portal-hyprland ];
    };

    services.dbus.enable = true;
    services.dbus.packages = [ pkgs.gcr ];

    environment.systemPackages = with pkgs;
      [
        #pamixer
        pulsemixer
        pavucontrol
        nautilus
        sushi
        gnome-calculator
        xdg-utils
        #xdg-desktop-portal
        #xdg-desktop-portal-wlr
        glib
        #dracula-theme
        #gnome3.adwaita-icon-theme
        wlr-randr
        wlsunset
        #nwg-displays
        wayland
        wayland-scanner
        wayland-utils
        # egl-wayland
        wayland-protocols
      ];

    hardware.graphics.enable = true;

    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    services.displayManager.gdm.enable = true;
    services.displayManager.defaultSession = "hyprland-uwsm";
    services.gvfs.enable = true;
    services.xserver.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
