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

    # You can also split up your configuration and import pieces of it here:
    # ./users.nix
    #./desktop.nix
    ./home-manager.nix
    # Import your generated (nixos-generate-config) hardware configuration
    ./hardware-configuration.nix
  ];

  nixpkgs = {
    # You can add overlays here
    overlays = [
      # If you want to use overlays exported from other flakes:
      # neovim-nightly-overlay.overlays.default

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

  # FIXME: Add the rest of your current configuration

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  programs.hyprland.enable = true;
  #programs.sway.enable = true;
  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  services.displayManager.defaultSession = "hyprland";

  # Configure keymap in X11
  #services.xserver = {
  # layout = "us";
  #  xkbVariant = "";
  #};

  hardware.opengl.enable = true;


  #  # Styling
  #  fonts = {
  #    packages = with pkgs; [
  #      noto-fonts
  #      noto-fonts-emoji
  #    ];
  #
  #    fontconfig = {
  #      # Fixes pixelation
  #      antialias = true;
  #
  #      # Fixes antialiasing blur
  #      hinting = {
  #        enable = true;
  #        style = "medium"; # no difference
  #        autohint = true; # no difference
  #      };
  #
  #      subpixel = {
  #        # Makes it bolder
  #        rgba = "rgb";
  #        lcdfilter = "default"; # no difference
  #      };
  #    };
  #  };
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  #sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  environment.systemPackages = [
    pkgs.wireplumber
    pkgs.brightnessctl
    pkgs.openconnect_openssl
  ];
  programs.evolution = {
    enable = true;
    plugins = [ pkgs.evolution-ews ];
  };
  # hardware = {
  #   pulseaudio = {
  #     enable = true;
  #     support32Bit = true;
  #     package = pkgs.pulseaudioFull;
  #   };
  # };
  services.dbus.enable = true;
  services.dbus.packages = [ pkgs.gcr ];

  virtualisation.docker.enable = true;

  # TODO: Set your hostname
  networking.hostName = "dell-notebook";


  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.


  users.users.matthias = {
    isNormalUser = true;
    description = "Matthias";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [
      firefox
      #  thunderbird
    ];
    shell = pkgs.zsh;
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

  #programs.alacritty.enable = true;
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "23.11";
}
