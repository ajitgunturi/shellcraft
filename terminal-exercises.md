# 5-Day Terminal Mastery Exercises
> Tools installed: eza · bat · fd · rg · fzf · zoxide · tmux · lazygit · git-delta · htop · tldr · jq · zsh-autosuggestions · zsh-syntax-highlighting · powerlevel10k

Each day builds on the previous. Budget ~30 minutes per session.

---

## Day 1 — Ground Floor: Navigation, Viewing, Searching

**Goal:** Replace the commands you already know with faster equivalents.

### 1.1 — eza (better `ls`)

```zsh
ls                        # icons, dirs grouped first
ll                        # long list: perms, size, date, owner
la                        # all files including hidden
lt                        # tree view, 2 levels deep
lt --level=3              # go deeper

# Sort tricks
eza -la --sort=size       # largest files last
eza -la --sort=modified   # most recently changed last
```

**Exercise:** Run `lt` in your `~/workspace` directory. Find the deepest nested file.

---

### 1.2 — bat (better `cat`)

```zsh
bat ~/.zshrc              # syntax highlighted, line numbers, git changes marked
bat -n ~/.zshrc           # line numbers only
bat -p ~/.zshrc           # plain — no decorations (good for piping)
bat --list-themes         # see available themes
bat --theme=Dracula ~/.zshrc

# bat as a pager for man pages
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
man git                   # try it
```

**Exercise:** Use `bat` to view your `.gitconfig`. Notice git-changed lines are highlighted in the gutter.

---

### 1.3 — fd (better `find`)

```zsh
fd                        # list everything in current dir (respects .gitignore)
fd .zsh ~                 # files ending in .zsh under home
fd -t f .md               # only files (-t f) with .md extension
fd -t d src               # only directories named 'src'
fd -H .env                # include hidden files (-H)
fd -e sh ~ --exec bat {}  # find all .sh files and bat-view them

# With a max depth
fd -d 2 . ~/workspace     # max 2 levels deep
```

**Exercise:** Find all `.zsh` files under `~/.oh-my-zsh/custom`. Count them.

---

### 1.4 — rg (better `grep`)

```zsh
rg "alias"                # search current dir recursively
rg "alias" ~/.zshrc       # search specific file
rg -i "homebrew" ~        # case insensitive
rg -l "export" ~          # list files that match, not lines
rg -c "function" ~/.zshrc # count matches per file
rg --type zsh "plugin"    # only in .zsh files

# Context lines (like grep -C)
rg -C 2 "ZSH_THEME" ~/.zshrc   # 2 lines before and after
```

**Exercise:** Search your `.zshrc` for every line containing "fzf". Then search `~/.oh-my-zsh` for files that contain "powerlevel10k" — only list filenames.

---

### 1.5 — zoxide (smarter `cd`)

```zsh
# First, build up zoxide's database by navigating normally:
cd ~/workspace/family-finances
cd ~/workspace/meet-mind
cd ~/.oh-my-zsh/custom

# Now jump without full paths:
z family                  # matches ~/workspace/family-finances
z custom                  # matches ~/.oh-my-zsh/custom
z meet                    # matches ~/workspace/meet-mind

# zi = interactive fuzzy picker of your history
zi                        # opens fzf over your visited dirs, Enter to jump
```

**Exercise:** Visit 3 different directories with `cd`, then use `z` with a fragment to jump back to each one.

---

### Day 1 Checkpoint

- [ ] `ll` feels natural instead of `ls -la`
- [ ] You used `bat` to view a file
- [ ] You found a file with `fd` without using `find`
- [ ] You searched file contents with `rg` without using `grep`
- [ ] You jumped to a directory with `z`

---

## Day 2 — FZF: The Fuzzy Layer on Everything

**Goal:** Make `fzf` your primary interface for history, files, and shell navigation.

### 2.1 — The Three Core Key Bindings

```zsh
# Ctrl+R — fuzzy history search
# Type a fragment of any past command. Arrow keys navigate. Enter runs it.
# Ctrl+Y copies the selected command to clipboard without running.

# Ctrl+T — fuzzy file picker
# Inserts the selected file path at your cursor position.
# Useful: type `bat ` then press Ctrl+T to pick a file to view.

# Alt+C — fuzzy cd
# Opens fzf over subdirectories, Enter to cd into the selected one.
```

**Exercise:** Press `Ctrl+R` and type `git`. Browse your git command history. Press `Ctrl+C` to cancel without running anything.

---

### 2.2 — FZF Tab Completion

```zsh
# After installing fzf, ** triggers fuzzy completion
cd **<TAB>                # fuzzy pick a directory
bat **<TAB>               # fuzzy pick a file to view
kill **<TAB>              # fuzzy pick a process to kill
ssh **<TAB>               # fuzzy pick from known hosts
unset **<TAB>             # fuzzy pick an env variable to unset
export **<TAB>            # same
```

**Exercise:** Type `bat **` then press Tab. Navigate with arrow keys. Press Enter to open the file.

---

### 2.3 — FZF Inside Commands (piping)

```zsh
# Pipe anything into fzf to make it interactive
ls ~ | fzf               # pick a file from home
history | fzf            # browse full history interactively

# Preview window
ls ~ | fzf --preview 'bat --color=always {}'       # preview files as you browse
fd -t f . ~ | fzf --preview 'bat --color=always {}'

# Multi-select with Tab
fd -t f . ~/workspace | fzf --multi     # Tab to mark, Enter to output all selected
```

**Exercise:** Run `fd -t f . ~/.oh-my-zsh/custom | fzf --preview 'bat --color=always {}'`. Browse through the plugin files with a live preview.

---

### 2.4 — Your Custom Git FZF Aliases

These are defined in your `.zshrc`:

```zsh
# In a git repo:
gb    # (fgb) fuzzy branch switch — pick a branch and check it out
gl    # (fgl) fuzzy log browser — Enter copies the commit hash to clipboard
ga    # (fga) fuzzy git add — Tab multi-selects files to stage
gs    # (fgs) fuzzy stash browser — preview stash diffs
gd    # (fgd) fuzzy diff browser — browse changed files with delta preview
```

**Exercise:** In any git repo, run `gl`. Browse the log. Select a commit and confirm the hash is in your clipboard with `pbpaste`.

---

### 2.5 — FZF Environment Variable Tricks

```zsh
# Inspect what FZF settings are active
echo $FZF_DEFAULT_COMMAND        # what it uses to list files
echo $FZF_CTRL_T_COMMAND         # what Ctrl+T lists
echo $FZF_ALT_C_COMMAND          # what Alt+C lists

# Temporarily override for one session
export FZF_DEFAULT_OPTS="--height=60% --border"
fzf                              # see the difference
```

**Exercise:** Run `echo $FZF_CTRL_R_OPTS` to see your history search config. Identify which key copies a command to clipboard without running it (hint: look for `ctrl-y`).

---

### Day 2 Checkpoint

- [ ] Used `Ctrl+R` to find and re-run a past command
- [ ] Used `Ctrl+T` to insert a file path mid-command
- [ ] Tried `**<TAB>` completion at least once
- [ ] Used `gl` or `ga` in a git repository
- [ ] Piped something into `fzf` manually

---

## Day 3 — tmux: Working in Panes and Sessions

**Goal:** Stop closing terminals. Detach and re-attach. Split your screen.

### 3.1 — Session Basics

```zsh
tmux                          # start a new unnamed session
tmux new -s work              # start a named session called 'work'
tmux ls                       # list all sessions (from outside tmux)

# Inside tmux — all commands start with Ctrl+a (your prefix)
# Ctrl+a d       detach (session keeps running in background)
# Ctrl+a $       rename current session
# Ctrl+a s       fuzzy switch between sessions

tmux attach -t work           # re-attach to 'work' session
tmux attach                   # re-attach to most recent session
```

**Exercise:** Create a session named `dev`. Run `htop` inside it. Detach with `Ctrl+a d`. From the normal shell, run `tmux ls` to confirm it's still running. Re-attach.

---

### 3.2 — Windows (tabs inside a session)

```zsh
# Ctrl+a c       create a new window
# Ctrl+a ,       rename current window
# Ctrl+a w       fuzzy window picker
# Ctrl+a n       next window
# Ctrl+a p       previous window
# Ctrl+a 1-9     jump to window by number
# Ctrl+a &       close current window (confirms)
```

**Exercise:** Inside a tmux session, create 3 windows. Name them `edit`, `run`, `logs`. Practice switching between them with `Ctrl+a w` and by number.

---

### 3.3 — Panes (splits inside a window)

```zsh
# Ctrl+a |       vertical split (side by side)
# Ctrl+a -       horizontal split (top and bottom)
# Ctrl+a h/j/k/l navigate panes (vim keys)
# Ctrl+a z       zoom/unzoom current pane (full screen toggle)
# Ctrl+a x       close current pane
# Ctrl+a {       swap pane left
# Ctrl+a }       swap pane right
# Ctrl+a H/J/K/L resize pane (hold to repeat)
```

**Exercise:** Split your window into 3 panes: one vertical split, then split the right pane horizontally. Run a different command in each: `htop`, `ll ~`, and `bat ~/.zshrc`. Practice navigating with `Ctrl+a h/j/k/l`.

---

### 3.4 — Copy Mode (scroll and copy text)

```zsh
# Ctrl+a [       enter copy mode (scroll with arrow keys or vim keys)
# q              exit copy mode
# In copy mode:
#   v            begin selection (vim style)
#   y            yank selection to clipboard (via pbcopy)
#   /            search forward
#   ?            search backward
#   n            next match
#   N            previous match
```

**Exercise:** Run a command that produces many lines (`ll /opt/homebrew/bin`). Enter copy mode with `Ctrl+a [`. Scroll up with `k`. Search for `git` with `/git`. Press `y` to yank a line.

---

### 3.5 — Config Reload

```zsh
# After editing ~/.tmux.conf:
Ctrl+a r          # reloads config and shows "Config reloaded!"

# Your current .tmux.conf key settings worth memorizing:
# prefix = Ctrl+a  (not the default Ctrl+b)
# splits open in the same directory you're already in
# mouse is on — you can click panes and scroll
```

**Exercise:** Edit `~/.tmux.conf`. Add `set -g status-bg colour235` on the last line. Reload with `Ctrl+a r` and observe the status bar change.

---

### Day 3 Checkpoint

- [ ] Created a named tmux session and detached/re-attached
- [ ] Created 3 named windows in one session
- [ ] Split a window into 3 panes and navigated between them
- [ ] Used copy mode to scroll and yank text
- [ ] Reloaded tmux config live

---

## Day 4 — Git Power Workflow

**Goal:** Make every git operation faster — staging, browsing, diffing, fixing.

### 4.1 — lazygit Full Tour

```zsh
lazygit               # open in any git repo
```

Key bindings inside lazygit:

| Key | Action |
|-----|--------|
| `1-5` | Switch between panels (Status / Files / Branches / Commits / Stash) |
| `Space` | Stage/unstage file |
| `a` | Stage all files |
| `c` | Commit (opens editor) |
| `C` | Commit with custom message inline |
| `p` | Push |
| `P` | Pull |
| `b` | Branch panel — create, delete, checkout |
| `d` | Diff selected file |
| `e` | Open file in editor |
| `z` | Undo last action |
| `?` | Help / all keybindings |
| `q` | Quit |

**Exercise:** In a git repo with some changes, open `lazygit`. Stage individual files with Space. Write a commit message. Browse the commit log panel.

---

### 4.2 — git-delta (better diffs)

delta is set as your default pager in `.gitconfig`, so it's already active:

```zsh
git diff              # side-by-side diff with line numbers, syntax highlighting
git show HEAD         # colored commit view
git log -p            # full patch log with delta rendering

# delta directly
delta file1.txt file2.txt    # compare two files

# Your .gitconfig delta config:
# side-by-side = true
# navigate = true (n/N to jump between diff sections)
# syntax-theme = Dracula
```

**Exercise:** Make a change to any file in a git repo. Run `git diff`. Use `n` and `N` to jump between changed hunks. Notice the side-by-side layout.

---

### 4.3 — Your .gitconfig Aliases

```zsh
git st          # status -sb (short branch format)
git lg          # oneline graph log, last 20 commits
git ll          # detailed log with date, author, subject
git co main     # checkout
git br          # branch list
git cm "msg"    # commit -m
git ca          # commit --amend --no-edit (fix last commit)
git undo        # reset --soft HEAD~1 (uncommit, keep changes staged)
git wip         # add -A + commit "WIP" in one shot
git unwip       # undo the WIP commit
git recent      # branches sorted by last commit date
git cleanup     # delete branches already merged into main
git stash-all   # stash including untracked files
git aliases     # list all your git aliases
```

**Exercise:** In a repo, run `git lg`. Then make a bad commit and use `git undo` to uncommit it while keeping your changes. Then use `ga` (your fzf alias) to re-stage just what you want.

---

### 4.4 — git-absorb (fixup commits automatically)

`git absorb` automatically identifies which staged changes belong to which previous commit and creates the right `fixup!` commits — then you rebase them in.

```zsh
# Workflow:
git log --oneline -5             # identify the commit to fix
# (edit the file to fix a bug introduced in a recent commit)
git add <fixed-file>             # stage the fix
git absorb                       # auto-creates fixup! commits
git rebase -i --autosquash HEAD~5   # squash fixups into their parents
```

**Exercise:** Make 2 commits in a test repo. Go back and fix something from the first commit. Stage the fix and run `git absorb --dry-run` to see what it would do.

---

### 4.5 — rerere (reuse recorded resolutions)

`rerere` is enabled in your `.gitconfig`. It records how you resolve merge conflicts so that if the same conflict appears again (common during rebases), it resolves it automatically.

```zsh
git config --global rerere.enabled    # verify: should print 'true'

# It works silently. After manually resolving a conflict:
git rerere                            # shows what was recorded
ls .git/rr-cache/                     # cached resolutions live here
```

**Exercise:** Run `git config --global --list | rg rerere` to confirm it's active. Run `git rerere status` in any repo to see its state.

---

### Day 4 Checkpoint

- [ ] Used lazygit to stage, commit, and browse log
- [ ] Viewed a `git diff` through delta with side-by-side layout
- [ ] Used at least 3 git aliases from `.gitconfig`
- [ ] Ran `git absorb --dry-run` on a staged fix
- [ ] Confirmed rerere is enabled

---

## Day 5 — Integration: Real Workflows + Make It Yours

**Goal:** Combine everything into fluid workflows. Customize your setup.

### 5.1 — The "Project Start" Workflow

Every time you start a work session, practice this sequence:

```zsh
# 1. Jump to project (zoxide)
z meet-mind           # or z family, etc.

# 2. Start (or re-attach) a named tmux session
tmux new -s meet 2>/dev/null || tmux attach -t meet

# 3. Set up windows (inside tmux)
# Ctrl+a c  → name it 'code'  (Ctrl+a ,)
# Ctrl+a c  → name it 'git'
# Ctrl+a c  → name it 'run'

# 4. In 'git' window, open lazygit
lazygit

# 5. In 'code' window, split and run your editor + bat for reference
# Ctrl+a |  → right pane: bat the file you're about to edit

# 6. In 'run' window, keep a shell ready for test runs
```

**Exercise:** Set up the full 3-window tmux session for one of your real projects. Keep it running. Practice detaching and re-attaching.

---

### 5.2 — The "Find Anything" Workflow

```zsh
# Find a file whose name you half-remember
fd "finance" ~/workspace          # filename fragment
fd -e md ~/workspace              # by extension

# Find code containing something
rg "TODO" ~/workspace             # all TODOs across projects
rg "def.*auth" ~/workspace        # functions with 'auth' in name
rg -l "import pandas"             # which files use pandas

# Combine fd + fzf + bat for exploration
fd -t f . ~/workspace | fzf --preview 'bat --color=always {}'
```

**Exercise:** Use `rg` to find all TODO comments across your entire `~/workspace`. Then use `fd | fzf` with preview to browse and read interesting files.

---

### 5.3 — The "History as Documentation" Workflow

Your history is set to 100,000 entries with deduplication and timestamps.

```zsh
# Review what you did recently
h                           # last 30 commands
history | rg "docker"       # everything you've ever run with docker
history | rg "git push"     # your push history

# Ctrl+R with multi-word search (fzf matches non-contiguous)
# Press Ctrl+R, then type: "brew install" — finds any brew install commands
# Type: "git commit main" — finds commits to main
```

**Exercise:** Search your history for every `brew install` command you've run. Then search for any command that touched a file in `~/workspace`.

---

### 5.4 — jq: JSON on the command line

```zsh
# Basic prettify
echo '{"name":"ajit","role":"dev"}' | jq .

# Extract a field
curl -s https://api.github.com/users/github | jq '.name, .public_repos'

# Filter an array
echo '[{"id":1,"ok":true},{"id":2,"ok":false}]' | jq '.[] | select(.ok)'

# Combine with fzf
curl -s https://api.github.com/users/github/repos | \
    jq '.[].name' | fzf
```

**Exercise:** Run `jq --version` to confirm it's installed. Then prettify any JSON file in your projects with `bat` (it auto-detects JSON and highlights it).

---

### 5.5 — Make It Yours: Custom Aliases

Your aliases file lives at `~/.oh-my-zsh/custom/aliases.zsh`. This is the one file you should customize freely — Oh My Zsh loads all `*.zsh` files in that directory automatically, so no source line is needed.

```zsh
bat ~/.oh-my-zsh/custom/aliases.zsh   # view the current file
```

Suggested additions (pick what fits your workflow):

```zsh
# --- Project shortcuts ---
alias proj="z workspace"
alias meet="z meet-mind"
alias fin="z family-finances"

# --- tmux shortcuts ---
alias tl="tmux ls"
alias ta="tmux attach -t"
alias tn="tmux new -s"

# --- Dev shortcuts ---
alias py="python3"
alias ve="python3 -m venv .venv && source .venv/bin/activate"
alias activate="source .venv/bin/activate"

# --- Safety nets ---
alias rm="rm -i"          # confirm before delete
alias cp="cp -i"          # confirm before overwrite

# --- Quick edits ---
alias zshconfig="bat ~/.zshrc"
alias myaliases="bat ~/.oh-my-zsh/custom/aliases.zsh"
alias editaliases="vim ~/.oh-my-zsh/custom/aliases.zsh && source ~/.oh-my-zsh/custom/aliases.zsh"
```

After editing, reload without restarting:

```zsh
reload              # your alias: source ~/.zshrc && echo '✔ Reloaded!'
```

**Exercise:** Add at least 3 aliases that match your real projects/workflow. Reload and test them.

---

### 5.6 — Version Your Customisations

Your configs (`~/.zshrc`, `~/.gitconfig`, `~/.tmux.conf`) are plain files at `$HOME` — the setup script regenerates them from its template on every run. Your only freely-edited file is:

```
~/.oh-my-zsh/custom/aliases.zsh   ← never overwritten by the script
```

To back it up, copy it into the `setup-my-workstation` repo — your personalisation lives alongside the script that generated your environment.

```zsh
cp ~/.oh-my-zsh/custom/aliases.zsh ~/workspace/setup-my-workstation/aliases.zsh

cd ~/workspace/setup-my-workstation
git st                                      # see what changed
git add aliases.zsh
git cm "add personal aliases"
git push
```

If you haven't pushed the repo to GitHub yet:

```zsh
cd ~/workspace/setup-my-workstation
gh repo create setup-my-workstation --private --source=. --push
```

On your next Mac, the full workflow becomes:

```zsh
git clone git@github.com:you/setup-my-workstation.git ~/workspace/setup-my-workstation
cp ~/workspace/setup-my-workstation/aliases.zsh ~/.oh-my-zsh/custom/aliases.zsh
~/workspace/setup-my-workstation/setup-my-mac.sh
```

**Exercise:** Copy your `aliases.zsh` into the `setup-my-workstation` repo. Commit and push it. Your environment is now fully reproducible from a single `git clone`.

---

### Day 5 Checkpoint

- [ ] Set up a full tmux workspace for a real project
- [ ] Used `rg` across your whole workspace to find something useful
- [ ] Searched history with `Ctrl+R` for multi-word fragments
- [ ] Used `jq` to inspect JSON output
- [ ] Added personal aliases to `~/.oh-my-zsh/custom/aliases.zsh` and reloaded
- [ ] Backed up `aliases.zsh` to the `setup-my-workstation` repo and pushed

---

## Quick Reference Card

### Key Bindings
| Binding | Action |
|---------|--------|
| `Ctrl+R` | Fuzzy history search |
| `Ctrl+T` | Fuzzy file picker (inserts path) |
| `Alt+C` | Fuzzy cd |
| `Ctrl+Space` | Accept autosuggestion |
| `→` | Accept autosuggestion (alternative) |
| `**<Tab>` | Fuzzy completion for current command |

### Command Replacements
| Old | New | Why |
|-----|-----|-----|
| `ls` / `ls -la` | `ls` / `ll` | eza: icons, git status, colors |
| `cat` | `cat` / `bat` | bat: syntax highlight, line numbers |
| `grep` | `grep` / `rg` | ripgrep: faster, respects .gitignore |
| `find` | `find` / `fd` | fd: simpler syntax, faster |
| `cd` (repeat) | `z` | zoxide: learned jump |
| `top` | `top` / `htop` | htop: interactive, mouse support |
| `git diff` | `git diff` | same command, delta renders it |
| `man` | `tldr` | tldr: practical examples first |

### tmux Prefix = `Ctrl+a`
| Binding | Action |
|---------|--------|
| `d` | Detach session |
| `c` | New window |
| `,` | Rename window |
| `w` | Window picker |
| `\|` | Vertical split |
| `-` | Horizontal split |
| `h/j/k/l` | Navigate panes |
| `z` | Zoom pane toggle |
| `[` | Scroll / copy mode |
| `r` | Reload config |

### Git Aliases (your .gitconfig)
| Alias | Expands to |
|-------|-----------|
| `git st` | `status -sb` |
| `git lg` | `log --oneline --graph --all -20` |
| `git cm` | `commit -m` |
| `git ca` | `commit --amend --no-edit` |
| `git undo` | `reset --soft HEAD~1` |
| `git wip` | `add -A && commit -m 'WIP'` |
| `git recent` | branches by last commit date |
| `git cleanup` | delete merged branches |

### Git FZF Shortcuts (your .zshrc)
| Alias | Action |
|-------|--------|
| `gb` | Fuzzy branch switch |
| `gl` | Fuzzy log (copies hash) |
| `ga` | Fuzzy interactive add |
| `gs` | Fuzzy stash browser |
| `gd` | Fuzzy diff browser |
