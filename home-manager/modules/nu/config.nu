
# Language settings
$env.LC_ALL = "en_US.UTF-8"
$env.LANG = "en_US.UTF-8"

# History
$env.HISTORY_SAVE_PATH = $env.HOME + "/.nu_history"
#$env.HISTORY_MAX = 10000


# Directory stack (native to Nushell)
def gbs [] {
  let branch = (
    git branch |
    split row "\n" |
    str trim |
    where ($it !~ '\*') |
    where ($it != '') |
    str join (char nl) |
    fzf --no-multi
  )
  if $branch != '' {
    git switch $branch
  }
}
# Vi mode - enable with: nu --vi
# Keybindings are handled by the vi mode, not manual bindkeys

# fzf integration
def fzf_branch [] {
    nu --command-output=raw 'git branch --format=refname:short' | fzf --multi | lines | each {|l|
        if $l != "" {
            $l
        }
    }
}

def fzf_git [] {
    nu --command-output=raw 'git status --short' | fzf --multi | lines | each {|l|
        if $l != "" {
            $l | str trim -l
        }
    }
}

def fzf_files [] {
    fd --type=general | fzf --height=50% | lines | each {|l|
        $l
    }
}

def fzf_cd [] {
    fd --type=directory | fzf --height=50% | lines | first |
    if it != null {
        "cd ($it)"
    } else {
        null
    }
}

# Set up command shortcuts (run with ^b, ^g, ^t, ^f when vi mode enabled)

#bind \b fzf_branch
#bind \g fzf_git
#bind \t fzf_files
#bind \f fzf_cd
$env.config = ($env.config | upsert keybindings [
  {
    name: "fzf_files"
    modifier: Control
    keycode: { char: 't' }
    mode: [emacs, vi_normal, vi_insert]
    event: { send: "fzf_files" }
  }
])

# Editor and pager
$env.PAGER = "less"
$env.LS_COLORS = "$nu.path"
$env.LS_HYPERLINK = true

