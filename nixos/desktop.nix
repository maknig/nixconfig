{ config
, lib
, pkgs
, inputs
, ...
}:
with lib; let
  cfg = config.dots.profiles.desktop;
in
{
  options.dots.profiles.desktop = {
    enable = mkEnableOption "desktop profile";
  };

  config = mkIf cfg.enable {


    security.rtkit.enable = true;

    hardware.pulseaudio.enable = false;
    #hardware = {
    #  pulseaudio = {
    #    enable = true;
    #    support32Bit = true;
    #    package = pkgs.pulseaudioFull;
    #  };
    #};

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

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
      # gtkUsePortal = true;
    };

    environment.systemPackages = with pkgs;
      [
        pamixer
        pulsemixer
        nautilus
        sushi
        gnome-calculator
        xdg-utils
        glib
        #dracula-theme
        #gnome3.adwaita-icon-theme
        wlr-randr
        wlsunset
        nwg-displays
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

    services.xserver.displayManager.gdm.enable = true;
    services.displayManager.defaultSession = "hyprland-uwsm";
    services.gvfs.enable = true;
    services.xserver.enable = true;

    environment.sessionVariables.NIXOS_OZONE_WL = "1";
  };
}
