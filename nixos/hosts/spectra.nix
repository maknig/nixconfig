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

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ ];


  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0206fa2e-67ed-48d3-b248-746844929271";
    fsType = "ext4";
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/2D6D-5C59";
    fsType = "vfat";
  };

  swapDevices = [ ];

}
