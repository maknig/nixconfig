
# Language settings
$env.LC_ALL = "en_US.UTF-8"
$env.LANG = "en_US.UTF-8"

# Editor and pager
$env.PAGER = "less"
$env.LS_COLORS = "$nu.path"
$env.LS_HYPERLINK = true

# --- editor / UX ---
$env.config.show_banner = false
$env.config.edit_mode = "vi"
$env.config.cursor_shape.vi_normal = "block"   # steady block in normal (matches zsh)
$env.config.cursor_shape.vi_insert = "line"    # beam in insert (matches zsh)

# --- completions (carapace sets .external.completer after this, via home-manager) ---
$env.config.completions.algorithm = "fuzzy"

# --- history: sqlite (better dedup + search; helps the Ctrl-R fzf widget) ---
# Note: with sqlite the history lives at ~/.config/nushell/history.sqlite3.
# One-time migration of old plaintext history: `history import`.
$env.config.history.file_format = "sqlite"
$env.config.history.max_size = 1_000_000

# --- niceties ---
$env.config.ls.clickable_links = true
$env.config.table.mode = "rounded"

# git branch switch via fzf
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

# --- fzf widgets (ported from the zsh config) --------------------------------
# Bound below to Ctrl-F/T/B/G/R. The keybindings run these via
# `executehostcommand`, which is how a keypress runs shell logic in Nushell.

# Ctrl-F: fuzzy cd. `def --env` so the `cd` actually changes the shell's dir.
def --env fzf_cd [] {
  let dir = (fd --type directory
    | fzf --layout reverse --height 50%
        --preview 'eza --header --git --time-style=long-iso --icons --no-permissions --no-user --long --sort=name {}')
  if ($dir | str trim | is-not-empty) { cd ($dir | str trim) }
}

# Ctrl-T: pick a file/dir and insert its path at the cursor.
def fzf_files [] {
  fd | fzf --layout reverse --height 50% --preview 'file {}; echo; cat {}' | str trim
}

# Ctrl-B: pick a git branch (local + remote, deduped) and insert it.
def fzf_branch [] {
  [ (git branch --format '%(refname:short)')
    (git branch --remotes --format '%(refname:lstrip=3)')
    (git branch --remotes --format '%(refname:short)') ]
  | str join (char newline) | lines | where {|b| $b | is-not-empty }
  | uniq | sort | str join (char newline)
  | fzf | str trim
}

# Ctrl-G: pick files from `git status --short` and insert them (space joined).
def fzf_git [] {
  git status --short
  | fzf --nth '2..' --multi
  | lines | each {|l| $l | str substring 3.. } | str join ' '
}

# Ctrl-R: fuzzy history. Seeds fzf with the current line, replaces it on
# select, and leaves the line untouched on cancel. `--read0` + null_byte keeps
# multi-line history entries intact.
def fzf_history [] {
  let cur = (commandline)
  let sel = (history | get command | reverse | uniq
    | str join (char null_byte)
    | fzf --read0 --scheme history --layout reverse --height 50% --query $cur
    | str trim)
  if ($sel | is-not-empty) { commandline edit --replace $sel }
}

$env.config.keybindings ++= [
  { name: fzf_cd      modifier: control keycode: char_f mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand cmd: "fzf_cd" } }
  { name: fzf_files   modifier: control keycode: char_t mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand cmd: "commandline edit --insert (fzf_files)" } }
  { name: fzf_branch  modifier: control keycode: char_b mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand cmd: "commandline edit --insert (fzf_branch)" } }
  { name: fzf_git     modifier: control keycode: char_g mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand cmd: "commandline edit --insert (fzf_git)" } }
  { name: fzf_history modifier: control keycode: char_r mode: [emacs vi_normal vi_insert]
    event: { send: executehostcommand cmd: "fzf_history" } }
]
