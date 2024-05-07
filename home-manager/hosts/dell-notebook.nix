{ ... }:

{
  home.stateVersion = "23.05";
  home.sessionPath = [ "$HOME/.nix-profile/bin" "$HOME/bin" ];

  dots = {
    alacritty.font_size = 14.0;
    alacritty.font_normal = "UbuntuMono Nerd Font Mono";
    alacritty.enable = true;
  };
}
