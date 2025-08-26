{
  description = "Matthias nix config";

  inputs = {
    # Nixpkgs
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    #nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
    #nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    # Home manager
    #home-manager.url = "github:nix-community/home-manager/release-23.05";
    #home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };


    hyprpaper = {
      url = "github:hyprwm/hyprpaper";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hypr-contrib = {
      url = "github:hyprwm/contrib";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    semshi-nvim = {
      url = github:numirias/semshi;
      flake = false;
    };

    micro-py-nvim = {
      url = github:jim-at-jibba/micropython.nvim;
      flake = false;
    };
    toggelterm-nvim = {
      url = github:akinsho/toggleterm.nvim;
      flake = false;
    };
    which-key = {
      url = github:folke/which-key.nvim;
      flake = false;
    };

    python-synt-nvim = {
      url = github:vim-python/python-syntax;
      flake = false;
    };

    hop-nvim = {
      url = github:phaazon/hop.nvim;
      flake = false;
    };

    fugitive-nvim = {
      url = github:tpope/vim-fugitive;
      flake = false;
    };

    gitsigns-nvim = {
      url = github:lewis6991/gitsigns.nvim;
      flake = false;
    };

    lsp-indicator-nvim = {
      url = github:dkuettel/lsp-indicator.nvim;
      flake = false;
    };

    funky-formatter-nvim = {
      url = github:dkuettel/funky-formatter.nvim;
      flake = false;
    };

    funky-contexts-nvim = {
      url = github:dkuettel/funky-contexts.nvim;
      flake = false;
    };

    comment-nvim = {
      url = github:numToStr/Comment.nvim;
      flake = false;
    };

    nightfox-nvim = {
      url = github:EdenEast/nightfox.nvim;
      flake = false;
    };

    web-devicons-nvim = {
      url = github:nvim-tree/nvim-web-devicons;
      flake = false;
    };

    lualine-nvim = {
      url = github:nvim-lualine/lualine.nvim;
      flake = false;
    };

    nvim-lspconfig = {
      url = github:neovim/nvim-lspconfig;
      flake = false;
    };

    nvim-cmp = {
      url = github:hrsh7th/nvim-cmp;
      flake = false;
    };

    cmp-lsp-nvim = {
      url = github:hrsh7th/cmp-nvim-lsp;
      flake = false;
    };

    luasnip-nvim = {
      url = github:L3MON4D3/LuaSnip;
      flake = false;
    };

    cmp-buffer-nvim = {
      url = github:hrsh7th/cmp-buffer;
      flake = false;
    };

    cmp-path-nvim = {
      url = github:hrsh7th/cmp-path;
      flake = false;
    };

    lsp-signature-nvim = {
      url = github:ray-x/lsp_signature.nvim;
      flake = false;
    };

    cmp-luasnip-nvim = {
      url = github:saadparwaiz1/cmp_luasnip;
      flake = false;
    };

    lspkind-nvim = {
      url = github:onsails/lspkind.nvim;
      flake = false;
    };

    plenary-nvim = {
      url = github:nvim-lua/plenary.nvim;
      flake = false;
    };

    telescope-nvim = {
      url = github:nvim-telescope/telescope.nvim;
      flake = false;
    };

    telescope-fzf-native-nvim = {
      url = github:nvim-telescope/telescope-fzf-native.nvim;
      flake = false;
    };

    rustacean-nvim = {
      url = github:mrcjkb/rustaceanvim;
      flake = true;
    };

    neodev-nvim = {
      url = github:folke/neodev.nvim;
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , flake-utils
    , neovim-nightly-overlay
    , home-manager
    , ...
    } @ inputs:
      with self.lib; let
        inherit (self) outputs;
        # Supported systems for your flake packages, shell, etc.
        systems = [
          "aarch64-linux"
          "x86_64-linux"
          "aarch64-darwin"
        ];

        # This is a function that generates an attribute by calling a function you
        # pass to it, with each system as an argument
        forEachSystem = nixpkgs.lib.genAttrs systems;
        pkgsBySystem = forEachSystem (
          system:
          import inputs.nixpkgs {
            inherit system;

            config.allowUnfreePredicate = pkg:
              builtins.elem (self.lib.getName pkg)
                [
                  "ivsc-firmware"
                  "ivsc-firmware-unstable"
                  "ipu6-camera-bins"
                  "ipu6-camera-bins-unstable"
                  "google-chrome"
                  "nvidia-settings"
                  "nvidia-x11"

                  "spotify"
                ];

            config.allowUnfree = true;

            ## logseq still uses EOL electron 27
            #config.permittedInsecurePackages = [
            #  "electron-27.3.11"
            #];
          }
        );
        pkgsStableBySystem = forEachSystem (
          system:
          import inputs.nixpkgs-stable {
            inherit system;

          config.allowUnfree = true;
          }
        );

      in
      rec {
        inherit pkgsBySystem pkgsStableBySystem;
        lib = import ./lib { inherit inputs; } // inputs.nixpkgs.lib;

        # Formatter for your nix files, available through 'nix fmt'
        # Other options beside 'alejandra' include 'nixpkgs-fmt'
        formatter = forEachSystem (system: nixpkgs.legacyPackages.${system}.alejandra);

        homeConfigurations = mapAttrs' intoHomeManager {
          spectra = { user = "matthias"; };
          arkeia = { user = "matthias"; };
          nebula = { user = "matthias"; };
          aurora = { system = "aarch64-darwin"; };
        };

        # NixOS configuration entrypoint
        # Available through 'nixos-rebuild --flake .#your-hostname'
        nixosConfigurations = mapAttrs' intoNixOs {
          spectra = { };
          arkeia = { };
        };
        # CI build helper
        top =
          let
            systems = genAttrs
              (builtins.attrNames inputs.self.nixosConfigurations)
              (attr: inputs.self.nixosConfigurations.${attr}.config.system.build.toplevel);
            homes = genAttrs
              (builtins.attrNames inputs.self.homeConfigurations)
              (attr: inputs.self.homeConfigurations.${attr}.activationPackage);
          in
          systems // homes;
      };
}
