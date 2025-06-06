{ pkgs, config, ... }:
{
  programs.tmux = {
    enable = true;
    # aggressiveResize = true; -- Disabled to be iTerm-friendly
    baseIndex = 1;
    newSession = true;
    # Stop tmux+escape craziness.
    escapeTime = 0;
    # Force tmux to use /tmp for sockets (WSL2 compat)
    secureSocket = false;

    plugins = with pkgs; [
      tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
                # forward focus events
      set -g focus-events on

      # confirm before killing a window or the server
      bind-key k confirm kill-window
      bind-key K confirm kill-server

      bind-key Space choose-tree

      # Reload the file with Prefix r.
      bind r source-file ~/.tmux.conf

      set-option -g renumber-windows on

      set -g status-position top
      set -g status-left-length 32
      set -g status-right-length 150

      set-option -g status-bg "#3c3836"
      set-option -g status-fg "#d5c4a1"
      # set-option -g status-attr default

      # default window title colors
      set-option -g window-status-style 'fg=#d5c4a1,bg=default'

      # active window title colors
      set-option -g window-status-current-style 'fg=#fbf17c,bg=#504945'

      # pane border
      set-option -g pane-border-style 'fg=#d65d0e'
      set-option -g pane-active-border-style 'fg=#d65d0e'

      # message text
      # set-option -g message-bg "#2b303b"
      # set-option -g message-fg "#c0c5ce"

      # pane number display
      set-option -g display-panes-active-colour "#a3be8c"
      set-option -g display-panes-colour "#ebcb8b"

      # clock
      set-window-option -g clock-mode-colour "#fbf17c"

      # bell
      set-window-option -g window-status-bell-style fg="#2b303b",bg="#bf616a"

      # status bar
      set -g status-left ' #S |'
      set -g window-status-format " #I #W "
      set -g window-status-current-format " #I *#W "
      set -g status-right '#(rusty_tmux_state)' # '%A %m/%d %l:%M %p'

      # fix paths for new windows
      bind c new-window -c "#{pane_current_path}"

      setw -g mode-keys vi

      # Splitting panes.
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # xmonad likeish
      bind h resize-pane -L 5
      bind j resize-pane -D 5
      bind k resize-pane -U 5
      bind l resize-pane -R 5

      # Moving between windows.
      bind -r C-h select-window -t :-
      bind -r C-l select-window -t :+

      set-option -sa terminal-features 'alacritty:256:clipboard:ccolour:cstyle:focus:mouse:RGB:strikethrough:title:usstyle'
      set-option -sa terminal-overrides 'alacritty:256:clipboard:ccolour:cstyle:focus:mouse:RGB:strikethrough:title:usstyle'
    '';
  };

  programs.tmate = {
    enable = true;
    # FIXME: This causes tmate to hang.
    # extraConfig = config.xdg.configFile."tmux/tmux.conf".text;
  };

  home.packages = [
    # Open tmux for current project.
    (pkgs.writeShellApplication {
      name = "pux";
      runtimeInputs = [ pkgs.tmux ];
      text = ''
        PRJ="''$(zoxide query -i)"
        echo "Launching tmux for ''$PRJ"
        set -x
        cd "''$PRJ" && \
          exec tmux -S "''$PRJ".tmux attach
      '';
    })
  ];
}
