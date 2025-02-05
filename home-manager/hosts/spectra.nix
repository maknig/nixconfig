{ ... }: {
  #home.stateVersion = "24.11";
  home.sessionPath = [ "$HOME/.nix-profile/bin" "$HOME/bin" ];

  dots = {
    profiles = {
      linux.enable = true;
      hyprland.enable = true;
    };
    alacritty = {
      font_size = 14.0;
      font_normal = "UbuntuMono Nerd Font Mono";
      enable = true;
    };
  };
}
