{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.dots.profiles.darwin;
in
{
  options.dots.profiles.darwin = {
    enable = mkEnableOption "darwin profile";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      TERMINFO_DIRS = "$HOME/.nix-profile/share/terminfo:$TERMINFO_DIRS";
    };
    # copy (not symlink) .app bundles so Spotlight indexes them
    targets.darwin.linkApps.enable = false;
    targets.darwin.copyApps.enable = true;


  };
}
