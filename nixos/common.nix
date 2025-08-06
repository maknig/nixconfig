{ inputs, lib, config, pkgs, ... }: {


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
    experimental-features = "nix-command flakes";
    # Deduplicate and optimize nix store
    auto-optimise-store = true;
  };
  nix.optimise.automatic = true;

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  networking.networkmanager.enable = true;
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

  virtualisation.docker.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Zurich";
  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";


  # Enable CUPS to print documents.
  services.printing.enable = true;

  networking.networkmanager.plugins = [ pkgs.networkmanager-openconnect ];

  environment.systemPackages = [
    #pkgs.wireplumber
    pkgs.openconnect_openssl
    #pkgs.mpd-mpris
    #pkgs.playerctl
    pkgs.zsh
  ];

  programs.zsh.enable = true;

  services.dbus = {
    enable = true;
    packages = [ pkgs.gcr ];
  };

  # TODO: Configure your system-wide user settings (groups, etc), add more users as needed.



  users.defaultUserShell = pkgs.zsh;
  users.users.matthias = {
    isNormalUser = true;
    description = "Matthias";
    extraGroups = [ "networkmanager" "wheel" "docker" "dialout" "video" ];
  };


}
