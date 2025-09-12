{ pkgs, ... }: {
  # TODO: https://nix-community.github.io/home-manager/#sec-install-nixos-module
  # do we need to set?:
  # home-manager.useUserPackages = true;
  # home-manager.useGlobalPkgs = true;
  #programs.home-manager.enable = true;
  manual.manpages.enable = true; # home-manager man pages
  programs.man.enable = true; # nix pkgs man pages

  fonts.fontconfig.enable = true;

  home.packages = [
    pkgs.home-manager
    pkgs.signal-desktop
    pkgs.spotify
    pkgs.dua
    pkgs.eza
    pkgs.yazi
    pkgs.htop
    pkgs.btop
    pkgs.fd
    pkgs.jq
    pkgs.procs
    pkgs.logseq
    # fonts
    pkgs.fontconfig
    pkgs.nerd-fonts.ubuntu-mono
    #pkgs.nerd-fonts.ubuntu-mono
    #pkgs.nerdfonts
    #(pkgs.nerd-fonts.override { fonts = [ "UbuntuMono" "Iosevka" "ZedMono" ]; })

  ];

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";


  programs.direnv = {
    enable = true;
    config = {
      hide_env_diff = true;
    };
    nix-direnv.enable = true;
  };
  programs.fzf = {
    enable = true;
    # enableZshIntegration = true;
  };

  home.file.".lesskey".text = ''
    #command
    e forw-line
    u back-line
    n left-scroll
    i right-scroll
    h forw-screen
    H forw-forever
    ^h goto-end
    k back-screen
    ^k goto-line
    r repaint
    E repeat-search
    U reverse-search
    ff clear-search
  '';
}
