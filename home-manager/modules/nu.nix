{ config
, pkgs
, lib
, ...
}: {
  programs.nushell = {
    enable = true;
    loadSessionVariables = false;
    configFile.source = ./nu/config.nu;
  };
}
