export LSCOLORS="exfxcxdxbxegedabagacad"
export CLICOLOR=true

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_CTYPE=C.UTF-8

HISTFILE=~/.zsh_history
HISTSIZE=10000000
SAVEHIST=10000000

setopt NO_BG_NICE # don't nice background tasks
setopt NO_HUP
setopt NO_LIST_BEEP
setopt LOCAL_OPTIONS # allow functions to have local options
setopt LOCAL_TRAPS # allow functions to have local traps
setopt HIST_VERIFY
setopt PROMPT_SUBST
setopt CORRECT
setopt COMPLETE_IN_WORD

setopt SHARE_HISTORY # share history between sessions ???
setopt EXTENDED_HISTORY # add timestamps to history
setopt APPEND_HISTORY # adds history
setopt INC_APPEND_HISTORY SHARE_HISTORY  # adds history incrementally and share it across sessions
setopt HIST_IGNORE_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_SAVE_NO_DUPS

# use the directory stack for normal cd commands
setopt auto_pushd
# invert +/- for the directory stack (so "cd -2" jumps to the second last dir)
setopt pushd_minus
# ignore duplicates on the directory stack
setopt pushd_ignore_dups

# vim mode for zle
bindkey -v
export KEYTIMEMOUT=1 # quicker reaction to mode change (might interfere with other things) (1=0.1seconds)

ZLE_SPACE_SUFFIX_CHARS=$'&|'

autoload -U up-line-or-beginning-search down-line-or-beginning-search insert-files edit-command-line
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
zle -N insert-files
zle -N edit-command-line

# vim insert mode for colemak as default
bindkey -A viins main
bindkey -M viins '^k' up-line-or-beginning-search
bindkey -M viins '^j' down-line-or-beginning-search
# TODO this is really cool, start using it
# TODO ctrl-something does not know shift or not
# TODO ^f is mapped later for fzf stuff, need one place to know what is what?
# bindkey -M viins '^f' insert-files
bindkey -M viins '^f' insert-files
bindkey -M viins '^e' edit-command-line
bindkey -M viins '^h' run-help
# TODO currently used by osh, but not for colemak
# shift-enter would be nice ... not sure we can detect it
# alternatively vim-style: \e-se
# bindkey -M viins '^n' vi-open-line-below
# TODO plus there might be a thing that on enter continuation pushes back the lines?

bindkey '\e[A' history-search-backward
bindkey '\e[B' history-search-forward

# vim normal mode for colemak (stolen from dk)
function {

    function dk-vi-insert-at-beginning {
        zle vi-first-non-blank
        zle vi-insert
    }
    zle -N dk-vi-insert-at-beginning

    function dk-vi-insert-before-word {
        zle vi-backward-word
        zle vi-insert
    }
    zle -N dk-vi-insert-before-word

    function dk-vi-insert-before-Word {
        zle vi-backward-blank-word
        zle vi-insert
    }
    zle -N dk-vi-insert-before-Word

    function dk-vi-insert-after-word {
        zle vi-forward-word
        zle vi-add-next
    }
    zle -N dk-vi-insert-after-word

    function dk-vi-insert-after-Word {
        zle vi-forward-blank-word
        zle vi-add-next
    }
    zle -N dk-vi-insert-after-Word

    local binds=(

        # navigate
        b vi-backward-blank-word
        h vi-backward-char
        b vi-backward-word
        '0' vi-beginning-of-line
        $ vi-end-of-line
        Y vi-forward-blank-word
        l vi-forward-char
        m vi-first-non-blank
        w vi-forward-word
        # TODO should I use the vi-* versions here?
        # or make history handling completely separate
        # left hand here is often a better flow
        # no vi-* versions for plain line moves
        # u up-line-or-beginning-search
        # e down-line-or-beginning-search
        k up-line
        j down-line
        # TODO any way to just start from an empty mapping anyway?
        # consider options: -m, -rp to remove based on prefix
        # ok I think we make an empty one and bind it to main: bindkey -A mymap main
        # and first an empty one: bindkey -N mymap, or get it from viins? ins needs defaults
        # bindkey -M vicmd -r s

        # insert
        sn vi-insert
        si vi-add-next
        se vi-open-line-below
        su vi-open-line-above
        sm dk-vi-insert-at-beginning
        so vi-add-eol
        sl dk-vi-insert-before-word
        sL dk-vi-insert-before-Word
        sy dk-vi-insert-after-word
        sY dk-vi-insert-after-Word
        p vi-replace-chars

        # change (see viopp below)
        ss vi-change

        # delete (see viopp below)
        d vi-delete
        x vi-delete-char

        # history
        '^u' up-line-or-beginning-search
        '^e' down-line-or-beginning-search

        # miscellaneous
        '^xe' edit-command-line

    )

    bindkey -N vicmd
    bindkey -M vicmd $binds

    function dk-opp-line {
        CURSOR=0
        MARK=$#BUFFER
    }
    zle -N dk-opp-line

    function dk-opp-eol {
        MARK=$#BUFFER
    }
    zle -N dk-opp-eol

    local binds=(
        # TODO select-a-word includes trailing spaces
        # TODO select-a-shell-word refers to a full argument :)
        # TODO zsh actually has argument text objects, and surround-and-escape stuff :)
        n dk-opp-line
        e select-in-word
        E select-in-blank-word
        i dk-opp-eol
    )

    bindkey -N viopp
    bindkey -M viopp $binds
}

# TODO these hooks, should I chain? do others chain?
# the default already contained something. copy that function and chain?
function zle-line-init {
     echo -ne "\e[6 q"  # steady beam
}
zle -N zle-line-init

function zle-keymap-select {
    if [[ $KEYMAP == vicmd ]]; then
        echo -ne "\e[2 q"  # steady block
    elif [[ $KEYMAP == (viins|main) ]]; then
        # TODO also viopp and visual or something?
        echo -ne "\e[6 q"  # steady beam
    fi
}
zle -N zle-keymap-select

function zle-line-finish {
    echo -ne "\e[2 q"  # steady block
}
zle -N zle-line-finish

export MANPAGER='nvim +Man!'
export VISUAL=nvim
export EDITOR=nvim

LESS=''
LESS+='--status-column '  # mark matched lines on the left side
LESS+='--HILITE-UNREAD '  # mark next unread line (not working with --status-column?)
LESS+='--RAW-CONTROL-CHARS '  # pass ansi colors
LESS+='--chop-long-lines '  # don't wrap long lines
LESS+='--clear-screen '  # so that the view starts at the top always
# LESS+='--no-init '  # don't clear the screen after exit
LESS+='--clear-screen '  # complete redraw when scrolling
LESS+='--jump-target=.3 '  # the target (for example when searching) is put at 1/3 from the top
export LESS

export FZF_DEFAULT_OPTS='--bind=ctrl-e:down,ctrl-u:up,ctrl-g:jump-accept'

# git branches
function __fzf_branch () {
    function branches () {
        # local branches
        git branch --format '%(refname:short)'
        # remote branches that look like local branches
        git branch --remotes --format '%(refname:lstrip=3)'
        # remote branches
        git branch --remotes --format '%(refname:short)'
    }
    if local branch=$(branches | sort | uniq | fzf); then
        LBUFFER="${LBUFFER}$branch"
    fi
    zle reset-prompt
}
zle -N __fzf_branch
bindkey '^b' __fzf_branch


# items from git status
function __fzf_git () {
    # TODO this also lists already added files, maybe thats okay, lets see how it goes
    if local files=$(git status --short | fzf --nth=2.. --multi | awk -v ORS=' ' 'match($0, /.. (.*)/, m) { print m[1] }'); then
        # TODO not sure if we need some ${=files} or ${(f)files} for proper escaping?
        LBUFFER="${LBUFFER}$files"
    fi
    zle reset-prompt
}
zle -N __fzf_git
bindkey '^g' __fzf_git


# insert files and folders
function __fzf_files {
    if local f=$(fd | fzf --layout=reverse --height=50% --preview='file {}; echo; cat {}'); then
        LBUFFER+=$f
    fi
    zle reset-prompt
}
zle -N __fzf_files
bindkey '^t' __fzf_files


# change directory
function __fzf_cd {
    if local d=$(fd --type=directory | fzf --layout=reverse --height=50% --preview='eza --header --git --time-style=long-iso --icons --no-permissions --no-user --long --sort=name {}'); then
        cd $d
    fi
    zle reset-prompt
}
zle -N __fzf_cd
bindkey '^f' __fzf_cd
