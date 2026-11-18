{ inputs
, lib
, config
, pkgs
, ...
}: {

  dots.profiles.desktop.enable = false;
  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia-container-toolkit.enable = true;

  virtualisation.docker.daemon.settings = {
    features.cdi = true;
    default-runtime = "nvidia";
    runtimes.nvidia.path =
      "${pkgs.nvidia-container-toolkit.tools}/bin/nvidia-container-runtime";
  };

  # nvidia-container-runtime shells out to `runc`; dockerd's PATH on NixOS
  # doesn't include it, so pin the absolute path via its config file.
  environment.etc."nvidia-container-runtime/config.toml".text = ''
    disable-require = false

    [nvidia-container-cli]
      environment = []
      ldconfig = "@${pkgs.glibc.bin}/bin/ldconfig"
      load-kmods = true
      no-cgroups = false

    [nvidia-container-runtime]
      debug = "/dev/null"
      log-level = "info"
      mode = "auto"
      runtimes = ["${pkgs.runc}/bin/runc"]

      [nvidia-container-runtime.modes]
        [nvidia-container-runtime.modes.cdi]
          annotation-prefixes = ["cdi.k8s.io/"]
          default-kind = "nvidia.com/gpu"
          spec-dirs = ["/etc/cdi", "/run/cdi"]

    [nvidia-ctk]
      path = "${pkgs.nvidia-container-toolkit}/bin/nvidia-ctk"
  '';

  boot.kernelPackages = pkgs.linuxPackages_latest;

  boot = {

    consoleLogLevel = 0;

    initrd = {
      #kernelModules = [ "kvm-intel" ];
      kernelModules = [ ];
      availableKernelModules = [ "vmd" "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      #availableKernelModules = [ "nvme" "ata_generic" "ehci_pci" "ahci" "isci" "xhci_pci" "firewire_ohci" "usb_storage" "usbhid" "sd_mod" "sr_mod" ];
      verbose = false;
    };
    kernelModules = [ "kvm-intel" ];
    extraModulePackages = [ ];
    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];

    plymouth.enable = false;
  };

  #boot.loader.systemd-boot.enable = true;
  #boot.loader.efi.canTouchEfiVariables = true;


  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/a6a61820-3055-4991-8699-9772cc4c0ef6";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/2ED5-BF65";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/516bcc6f-7327-430e-bf9d-930a83bf2e7c"; }];
}
