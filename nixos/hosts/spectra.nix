{ inputs
, lib
, config
, pkgs
, ...
}: {

  dots.profiles.desktop.enable = true;

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  environment.systemPackages = [
    pkgs.brightnessctl
  ];


}
