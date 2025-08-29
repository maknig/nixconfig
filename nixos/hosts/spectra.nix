{ inputs
, lib
, config
, pkgs
, ...
}: {

 services.udev.extraRules = ''
    ACTION!="add|change", GOTO="probe_rs_rules_end"

    SUBSYSTEM=="gpio", MODE="0660", TAG+="uaccess"

    SUBSYSTEM!="usb|tty|hidraw", GOTO="probe_rs_rules_end"

    # STMicroelectronics ST-LINK V1
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3744", TAG+="uaccess"

    # STMicroelectronics ST-LINK/V2
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3748", TAG+="uaccess"

    # STMicroelectronics ST-LINK/V2.1
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374b", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3752", TAG+="uaccess"

    # STMicroelectronics STLINK-V3
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374d", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374e", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="374f", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3753", TAG+="uaccess"
    ATTRS{idVendor}=="0483", ATTRS{idProduct}=="3754", TAG+="uaccess"

    # SEGGER J-Link
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0101", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0102", TAG+="uaccess"
    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="0103", TAG+="uaccess"

    ATTRS{idVendor}=="1366", ATTRS{idProduct}=="106f", TAG+="uaccess"

    # CMSIS-DAP compatible adapters
    ATTRS{product}=="*CMSIS-DAP*", TAG+="uaccess"

    LABEL="probe_rs_rules_end"
  '';
    
  dots.profiles.desktop.enable = true;
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
  services.fwupd.enable = true;

  #hardware.enableAllFirmware = true;
  #hardware.enableRedistributableFirmware = true;

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

  #boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelPackages = pkgs.linuxPackages_6_15;
  #boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel"  "v4l2loopback"  ];
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
