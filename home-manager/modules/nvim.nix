{ pkgs
, inputs
, lib
, ...
}:
with builtins; let
  pyformat =
    pkgs.writeScriptBin "pyformat"
      ''
        #!/usr/bin/env zsh
        set -eu -o pipefail

        if [[ -f ./.venv/bin/ruff ]]; then
            ./.venv/bin/ruff check --fix-only --select 'I' -s - | ./.venv/bin/ruff format -s -
            exit $?
        fi

        ruff check --fix-only --select 'I' -s - | ruff format -s -
      '';

  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (p:
    with p; [
      c
      javascript
      json
      cpp
      go
      python
      typescript
      rust
      bash
      html
      haskell
      regex
      css
      toml
      nix
      clojure
      latex
      lua
      make
      markdown
      vim
      yaml
      glsl
      dockerfile
      graphql
      bibtex
      cmake
    ]);

  plug = name:
    pkgs.vimUtils.buildVimPlugin {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
      buildPhase = ''
        ${
          if name == "telescope-fzf-native-nvim"
          then "make"
          else ""
        }
      '';
      dependencies = [
        pkgs.vimPlugins.nvim-cmp
        pkgs.vimPlugins.telescope-nvim
        pkgs.vimPlugins.plenary-nvim
        pkgs.vimPlugins.toggleterm-nvim
        
      ];
    };
in
{
  programs = {
    neovim = {
      enable = true;
      package = pkgs.neovim;
      withPython3 = true;
      withNodeJs = true;

      #extraPackages = with pkgs; [
      #  imagemagick
      #];

      #extraLuaPackages = p: with p; [
      #  magick # for image rendering
      #];

      #extraPython3Packages = ps: with ps; [
      #  # ... other python packages
      #  pynvim
      #  jupyter-client
      #  cairosvg # for image rendering
      #  pnglatex # for image rendering
      #  plotly # for image rendering
      #  pyperclip
      #];

      plugins = with pkgs.vimPlugins; [
        (plug "hop-nvim")
        (plug "fugitive-nvim")
        #(plug "gitsigns-nvim")
        gitsigns-nvim
        (plug "lsp-indicator-nvim")
        (plug "funky-formatter-nvim")
        (plug "funky-contexts-nvim")
        (plug "comment-nvim")

        # theme
        (plug "nightfox-nvim")
        (plug "web-devicons-nvim")
        (plug "lualine-nvim")

        # lsp (minimal)
        (plug "nvim-lspconfig")
        #(plug "nvim-cmp")
        nvim-cmp
        (plug "cmp-lsp-nvim")

        ## lsp (ext completion)
        (plug "cmp-buffer-nvim")
        (plug "cmp-path-nvim")
        (plug "cmp-luasnip-nvim")
        (plug "lsp-signature-nvim")
        (plug "lspkind-nvim")

        #luasnip
        #nvim-cmp
        #cmp-path
        #cmp_luasnip

        # telescope
        #(plug "plenary-nvim")
        plenary-nvim
        (plug "telescope-nvim")
        (plug "telescope-fzf-native-nvim")

        (plug "rustacean-nvim")

        (plug "neodev-nvim")
        (plug "python-synt-nvim")
        (plug "micro-py-nvim")
        (plug "toggelterm-nvim")
        #(plug "jukit-nvim")

        #(plug "jukit-nvim")
        #(plug "semshi-nvim")

        # interesting navigation and term/tmux commands: https://github.com/ThePrimeagen/harpoon/tree/harpoon2

        # hugging face code completion
        # (plug "hfcc")

        # letting Nix manage treesitter: https://nixos.wiki/wiki/Treesitter
        treesitter
      ];
    };
  };

  home = {
    packages = with pkgs; [
      pyformat
      clang-tools
      pyright
      rust-analyzer
      sumneko-lua-language-server
      yaml-language-server
      # formatters
      black
      nixpkgs-fmt
      nodePackages.prettier
      nodePackages.typescript-language-server
      rustfmt
      stylua
      ruff
    ];
  };

  home.file.".config/nvim/init.lua".source = ./nvim/init.lua;
  home.file.".config/nvim/lua".source = ./nvim/lua;
  home.file.".config/nvim/ftplugin/help.vim".text = ''
    " see also /usr/local/share/nvim/runtime/ftplugin/help.vim
    nmap <silent><buffer> go gO<c-w>c<cmd>lua require("telescope.builtin").loclist({fname_width=0})<enter>
  '';
  home.file.".config/nvim/ftplugin/man.vim".text = ''
    " use this to find an entry interactively
    " TODO could also do something with telescope if we parse it using some
    " heuristics
    nmap <buffer> f /\C^ *
    nmap <buffer> - /\C^ *-

    " see also /usr/local/share/nvim/runtime/ftplugin/man.vim
    nnoremap <silent> <buffer> k <cmd>set scroll=0<enter><c-u><c-u>
    nnoremap <silent> <buffer> h <cmd>set scroll=0<enter><c-d><c-d>
    " TODO this mapping is not very well aligned yet
    " not bad, a bit hacky to "hide" the filename column
    nnoremap <silent> <buffer> go <cmd>lua require("man").show_toc()<enter><c-w>c<cmd>lua require("telescope.builtin").loclist({fname_width=0})<enter>
  '';
}
