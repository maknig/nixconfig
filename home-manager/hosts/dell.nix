{ ... }: {
  #home.stateVersion = "24.11";
  home.sessionPath = [ "$HOME/.nix-profile/bin" "$HOME/bin" ];
  home.sessionVariables = {
    LANG = "en_US.UTF-8";
    LC_ALL = "en_US.UTF-8";
    LC_CTYPE = "C.UTF-8";
  };
  dots = {
    profiles = {
      linux.enable = true;
      hyprland.enable = false;
    };
    alacritty = {
      font_size = 14.0;
      #font_normal = "UbuntuMono Nerd Font Mono";
      font_normal = "UbuntuMono Nerd Font Mono";
      enable = true;
    };
  };
}
