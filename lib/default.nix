{ inputs, ... }:
with inputs.nixpkgs.lib; let
  strToPath = x: path:
    if builtins.typeOf x == "string"
    then builtins.toPath "${toString path}/${x}"
    else x;
  strToFile = x: path:
    if builtins.typeOf x == "string"
    then builtins.toPath "${toString path}/${x}.nix"
    else x;
in
rec {
  existsOrDefault = x: set: default:
    if hasAttr x set
    then getAttr x set
    else default;

  mkUserHome =
    { config
    , system ? "x86_64-linux"
    ,
    }: { ... }: {
      imports = [
        (import ../home-manager/common)
        (import ../home-manager/modules)
        (import ../home-manager/profiles)
        (import config)
      ];

      # For compatibility with nix-shell, nix-build, etc.
      home.file.".nixpkgs".source = inputs.nixpkgs;
      home.sessionVariables."NIX_PATH" = "nixpkgs=$HOME/.nixpkgs\${NIX_PATH:+:}$NIX_PATH";

      # set in host? fallback
      home.stateVersion = "24.11";
    };

  intoHomeManager = name: { config ? name, user ? "matthias", system ? "x86_64-linux" }:
    let
      pkgs = inputs.self.pkgsBySystem."${system}";
      username = user;
      homeDirectory =
        if pkgs.stdenv.isDarwin
        then "/Users/${username}"
        else "/home/${username}";
    in
    nameValuePair name (
      inputs.home-manager.lib.homeManagerConfiguration {
        inherit pkgs;
        modules = [
          {
            home = { inherit username homeDirectory; };

            imports =
              let
                userConf = strToFile config ../home-manager/hosts;
                home = mkUserHome {
                  inherit system;
                  config = userConf;
                };
              in
              [ home ];

            nix = {
              package = pkgs.nixVersions.stable;
              extraOptions = "experimental-features = nix-command flakes";
            };

            nixpkgs = {
              overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
            };
          }
        ];
        extraSpecialArgs =
          let
            self = inputs.self;
          in
          { inherit inputs name self system; };
      }
    );

  intoNixOs = name: { config ? name
                    , user ? "matthias"
                    , system ? "x86_64-linux"
                    ,
                    }:
    nameValuePair name (
      let
        pkgs = inputs.self.pkgsBySystem."${system}";
        #userConf = import (strToFile user ../user);
      in
      nixosSystem {
        inherit system;
        modules = [
          (
            { name, ... }: {
              networking.hostName = name;
            }
          )
          (
            { inputs, ... }: {
              nixpkgs = {
                inherit pkgs;
                overlays = [ inputs.neovim-nightly-overlay.overlays.default ];
              };

              environment.etc.nixpkgs.source = inputs.nixpkgs;
              nix.nixPath = [ "nixpkgs=/etc/nixpkgs" ];
            }
          )
          (
            { pkgs, ... }: {
              nix = {
                package = pkgs.nixVersions.latest;
                settings = {
                  experimental-features = "nix-command flakes";
                  auto-optimise-store = true;
                };
              };
            }
          )
          (
            { inputs, ... }: {
              # re-expose self and nixpkgs as flakes.
              nix.registry = {
                self.flake = inputs.self;
                nixpkgs = {
                  from = {
                    id = "nixpkgs";
                    type = "indirect";
                  };
                  flake = inputs.nixpkgs;
                };
              };
            }
          )
          (
            { ... }: {
              system.stateVersion = "24.11";
            }
          )
          (inputs.home-manager.nixosModules.home-manager)
          {
            home-manager =
              {
                useGlobalPkgs = true;
                extraSpecialArgs =
                  let
                    self = inputs.self;
                    user = userConf;
                  in
                  # NOTE: Cannot pass name to home-manager as it passes `name` in to set the `hmModule`
                  { inherit inputs self system user; };

                # Define Home Manager configuration for the user
                users =
                  let
                    userConf = strToFile config ../home-manager/hosts;
                    home = mkUserHome {
                      inherit system;
                      config = userConf;
                    };

                  in
                  {
                    ${user} = home;
                  };
              };
          }
          (import (strToFile config ../nixos/hosts))
          (import ../nixos/desktop.nix)
          (import ../nixos/common.nix)
          (import ../nixos/hardware.nix)
        ];
        specialArgs =
          let
            self = inputs.self;
            #user = userConf;
          in
          { inherit inputs name self system; }; #user; };
      }
    );
}
