# This is your system's configuration file.
# Use this to configure your system environment (it replaces /etc/nixos/configuration.nix)
{ inputs
, lib
, config
, pkgs
, ...
}: {
  # You can import other NixOS modules here
  imports = [
    # If you want to use modules from other flakes (such as nixos-hardware):
    # inputs.hardware.nixosModules.common-cpu-amd
    # inputs.hardware.nixosModules.common-ssd

    #./desktop.nix
    ./home-manager.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      inputs.neovim-nightly-overlay.overlays.default

      # Or define it inline, for example:
      # (final: prev: {
      #   hi = final.hello.overrideAttrs (oldAttrs: {
      #     patches = [ ./change-hello-to-hi.patch ];
      #   });
      # })
    ];
    # Configure your nixpkgs instance
    config = {
      # Disable if you don't want unfree packages
      allowUnfree = true;
      #allowBroken = true;
    };
  };

  # This will add each flake input as a registry
  # To make nix3 commands consistent with your flake
  nix.registry = (lib.mapAttrs (_: flake: { inherit flake; })) ((lib.filterAttrs (_: lib.isType "flake")) inputs);

  # This will additionally add your inputs to the system's legacy channels
  # Making legacy nix commands consistent as well, awesome!
  nix.nixPath = [ "/etc/nix/path" ];
  environment.etc =
    lib.mapAttrs'
      (name: value: {
        name = "nix/path/${name}";
        value.source = value.flake;
      })
      config.nix.registry;

  nix.settings = {
    # Enable flakes and new 'nix' command
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };

  # Enable networking
  networking.networkmanager.enable = true;
  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";


  programs.hyprland.enable = true;
  # Optional, hint electron apps to use wayland:
  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  #programs.sway.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  services.displayManager.defaultSession = "hyprland";

  hardware.graphics.enable = true;

  hardware.ipu6 = {
    enable = true;
    platform = "ipu6ep";
    #platform = "ipu6";
  };

  services.udev.extraRules = ''
    # If the system is not a video device, we skip these rules by jumping to the end
    SUBSYSTEM!="video4linux", GOTO="hide_cam_end"
    #ATTR{name}=="Intel MIPI Camera", GOTO="hide_cam_end" # This line cannot be used as it would move too much stuff and then the camera would not work. Instead, we just move the dummy camera,
    # I found its name with udevadm info -q all -a /dev/video0
    # If this is not the dummy video, we also skip these rules.
    ATTR{name}!="Dummy video device (0x0000)", GOTO="hide_cam_end"
    ACTION=="add", RUN+="${pkgs.coreutils}/bin/mkdir -p /dev/not-for-user"
    ACTION=="add", RUN+="${pkgs.coreutils}/bin/mv -f $env{DEVNAME} /dev/not-for-user/"

    ACTION=="remove", RUN+="${pkgs.coreutils}/bin/rm -f /dev/not-for-user/$name"
    ACTION=="remove", RUN+="${pkgs.coreutils}/bin/rm -f /dev/not-for-user/$env{ID_SERIAL}"

    LABEL="hide_cam_end"
  '';

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  #hardware = {
  #   pulseaudio = {
  #     enable = true;
  #     support32Bit = true;
  #     package = pkgs.pulseaudioFull;
  #   };
  # };

  security.rtkit.enable = true;

  hardware.pulseaudio.enable = false;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.mpd = {
    enable = true;
    musicDirectory = "/home/matthias/Music";
    user = "matthias";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "My PipeWire Output"
      }
    '';

  };

  environment.systemPackages = [
    pkgs.wireplumber
    pkgs.brightnessctl
    pkgs.openconnect_openssl
    pkgs.networkmanager-openconnect
    pkgs.mpd-mpris
    pkgs.playerctl
    pkgs.zsh
  ];



  services.dbus = {
    enable = true;
    packages = [ pkgs.gcr ];
  };


  networking.hostName = "dell-notebook";


  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.

  programs.zsh.enable = true;

  users.defaultUserShell = pkgs.zsh;

  virtualisation.docker.enable = true;

  users.users.matthias = {
    isNormalUser = true;
    description = "Matthias";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" "video" ];
    #packages = with pkgs; [
    #  firefox
    #];
    #shell = pkgs.zsh;
  };


  # This setups a SSH server. Very important if you're setting up a headless system.
  # Feel free to remove if you don't need it.
  services.openssh = {
    enable = true;
    settings = {
      # Forbid root login through SSH.
      PermitRootLogin = "no";
      # Use keys only. Remove if you want to SSH using password (not recommended)
      PasswordAuthentication = false;
    };
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
