{ ... }: {
  #home.stateVersion = "24.11";
  #home.sessionPath = [ "$HOME/.nix-profile/bin" "$HOME/bin" ];

  dots = {
    profiles = {
      darwin.enable = true;
    };
    alacritty = {
      font_size = 16.0;
      font_normal = "UbuntuMono Nerd Font Mono";
      enable = true;
    };
  };
}
