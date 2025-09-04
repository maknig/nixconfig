{ pkgs
, inputs
, lib
, ...
}:
with builtins; let
  nvim-spell-de-utf8-dictionary = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/de.utf-8.spl";
    sha256 = "1ld3hgv1kpdrl4fjc1wwxgk4v74k8lmbkpi1x7dnr19rldz11ivk";
  };

  nvim-spell-de-utf8-suggestions = builtins.fetchurl {
    url = "https://ftp.nluug.nl/vim/runtime/spell/de.utf-8.sug";
    sha256 = "0j592ibsias7prm1r3dsz7la04ss5bmsba6l1kv9xn3353wyrl0k";
  };

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
      doCheck = false;
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

      plugins = with pkgs.vimPlugins; [
        (plug "hop-nvim")
        (plug "fugitive-nvim")
        #(plug "gitsigns-nvim")
        gitsigns-nvim
        (plug "lsp-indicator-nvim")
        (plug "funky-formatter-nvim")
        (plug "funky-contexts-nvim")
        (plug "comment-nvim")

        #conform-nvim
        formatter-nvim

        # theme
        (plug "nightfox-nvim")
        (plug "web-devicons-nvim")
        (plug "lualine-nvim")

        # lsp (minimal)
        (plug "nvim-lspconfig")
        #(plug "nvim-cmp")
        nvim-cmp
        cmp-spell
        (plug "cmp-lsp-nvim")

        ## lsp (ext completion)
        (plug "cmp-buffer-nvim")
        (plug "cmp-path-nvim")
        (plug "cmp-luasnip-nvim")
        (plug "lsp-signature-nvim")
        (plug "lspkind-nvim")

        luasnip
        #nvim-cmp
        #cmp-path
        #cmp_luasnip

        # telescope
        #(plug "plenary-nvim")
        plenary-nvim
        (plug "telescope-nvim")
        (plug "telescope-fzf-native-nvim")

        #(plug "rustacean-nvim")
        (plug "rustacean-nvim")

        (plug "neodev-nvim")
        (plug "python-synt-nvim")
        (plug "micro-py-nvim")
        (plug "toggelterm-nvim")

        #(plug "jukit-nvim")

        render-markdown-nvim
        molten-nvim
        image-nvim
        #markview-nvim
        img-clip-nvim
        dressing-nvim
        nui-nvim
        codecompanion-nvim
        #(plugAvante "avante-nvim")

        #(plug "semshi-nvim")

        nvim-dap-ui
        nvim-dap
        which-key-nvim
        # letting Nix manage treesitter: https://nixos.wiki/wiki/Treesitter
        treesitter
      ];
    };
  };

  home = {
    packages = with pkgs; [
      ripgrep
      pyformat
      clang-tools
      pyright
      basedpyright
      rust-analyzer
      sumneko-lua-language-server
      yaml-language-server
      texlab
      # formatters
      black
      nixpkgs-fmt
      nodePackages.prettier
      nodePackages.typescript-language-server
      rustfmt
      stylua
      ruff
      taplo
      tex-fmt
    ];
  };

  xdg.configFile."nvim/spell/de.utf-8.spl".source = nvim-spell-de-utf8-dictionary;
  xdg.configFile."nvim/spell/de.utf-8.sug".source = nvim-spell-de-utf8-suggestions;

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
