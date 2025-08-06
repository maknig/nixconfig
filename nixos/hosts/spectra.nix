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
  services.fwupd.enable = true;

  hardware.enableAllFirmware = true;
  hardware.enableRedistributableFirmware = true;

  environment.systemPackages = [
    pkgs.brightnessctl
  ];

  # fix ipu6 build failure
  #boot.kernelPackages = pkgs.linuxPackages_latest.extend (_: prev: {
  #  ipu6-drivers = prev.ipu6-drivers.overrideAttrs (_: _: {
  #    src = pkgs.fetchFromGitHub {
  #      owner = "intel";
  #      repo = "ipu6-drivers";
  #      rev = "e2136ae84dac25d6e0be071bda460d852bb975d1";
  #      #rev = "19c1deddd2274016ed0b8b5eed804bb1e2f6fee7";
  #      hash = "sha256-HLo3gC61+nRUMzonc3d5uwy+OmWQMQkLAGj15Ynbcoc=";
  #    };
  #  });
  #});

  boot.kernelPackages = pkgs.linuxPackages_latest;
  #boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/539b1780-5d09-4a7d-805f-0e02601540c2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/708D-01E5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/a869d50f-7147-49d9-b813-18891c89d35b"; }];


}
