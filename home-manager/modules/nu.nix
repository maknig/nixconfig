{ config
, pkgs
, lib
, ...
}: {
  programs.nushell = {
    enable = true;
    configFile.source = ./nu/config.nu;
  };
}
