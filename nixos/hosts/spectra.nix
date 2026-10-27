{ inputs
, lib
, config
, pkgs
, ...
}: {
  imports = [
    ../modules/probe-rs-udev.nix
    inputs.globalprotect-openconnect.nixosModules.default
  ];

  programs.globalprotect-openconnect.enable = true;


  dots.profiles.desktop.enable = true;
  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
  };

  hardware.bluetooth.enable = true;

  services.blueman.enable = true;
  services.fwupd.enable = true;

  # Intel RealSense udev rules
  #services.udev.packages = [ pkgs.librealsense ];

  #hardware.enableAllFirmware = true;
  #hardware.enableRedistributableFirmware = true;
  #  fonts = {
  #    enableDefaultPackages = true;
  #  fontconfig.enable = true;
  #    packages = with pkgs; [
  #      font-adobe-100dpi
  #      font-adobe-75dpi
  #      font-alias
  #    ];
  #  };
  #  services.xserver.fontPath = "/run/current-system/sw/share/X11/fonts/100dpi,/run/current-system/sw/share/X11/fonts/75dpi";
  services.printing = {
    enable = true;
    drivers = [ pkgs.hplip ]; # Includes PPDs and tools for HP printers
  };

  # Enable network discovery (mDNS / IPP Everywhere)
  services.avahi = {
    enable = false;
    nssmdns4 = false;
    openFirewall = false;
  };

  services.samba = {
    enable = true;
    smbd.enable = false;
    nmbd.enable = false;
    winbindd.enable = false;
  };

  hardware.printers = {
    ensurePrinters = [
      {
        name = "HP_Color_LaserJet_M577";
        location = "8.102";
        deviceUri = "smb://print-rj-c.ost.ch/d8102-a4mfp";
        model = "HP/hp-color_laserjet_mfp_m577-ps.ppd.gz";
        ppdOptions = {
          # No credentials stored anywhere in this config/git repo.
          # This just tells CUPS the queue needs a login; the username/password
          # are typed at print time (desktop print dialog or CUPS web UI prompt).
          "auth-info-required" = "username,password";
        };
      }
    ];
    ensureDefaultPrinter = "HP_Color_LaserJet_M577";
  };
 

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
  #boot.kernelPackages = pkgs.linuxPackages_6_15;
  #boot.kernelPackages = pkgs.linuxPackages_6_12;
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "thunderbolt" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" "v4l2loopback" ];
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
