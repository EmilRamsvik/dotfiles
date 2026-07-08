# Zsh & Terminal Review — July 2026

A thorough review of the oh-my-zsh setup, a comparison against popular dotfiles
configs on GitHub, and the changes made as a result. The theme goal: make the
terminal *feel* better — faster startup, richer feedback while typing, and a
visual style built on the brand palette (Grå `#1A1A1A`, Oransje `#FF8C45`,
Gul `#FFD24C`, Blå `#97D2EC`, Off-white `#FCF6EE`).

---

## 1. Review findings (before)

### 🔴 Critical: none of the oh-my-zsh plugins were loading

`.zshrc` sourced `oh-my-zsh.sh` on line 18, but the `plugins=(...)` array was
defined in `zsh/plugins.zsh` — sourced on line 34. OMZ reads `$plugins` **at
load time**, so the entire plugin list (git, docker, autosuggestions, syntax
highlighting, …) was silently ignored. On top of that, `zsh-autosuggestions`
was never installed anywhere (not in the Brewfile, not cloned into
`$ZSH_CUSTOM/plugins`), so it couldn't have loaded even with correct ordering.

**Fix:** `.zshrc` now sources `environment.zsh` and `plugins.zsh` *before*
oh-my-zsh, and `setup.sh` clones the custom plugins into `$ZSH_CUSTOM/plugins`.

### 🟠 Performance problems

| Issue | Cost | Fix |
|---|---|---|
| `compinit` ran twice (OMZ runs it, `settings.zsh` ran it again) | ~0.25–1s per shell | removed from `settings.zsh` |
| nvm sourced eagerly in `environment.zsh` | ~500ms+ per shell | OMZ `nvm` plugin with `zstyle ':omz:plugins:nvm' lazy yes` |
| `thefuck --alias` eval'd twice at startup | ~150ms | removed (see §3, tool is dead) |
| `$(brew --prefix)` subshell for autojump | ~50ms | replaced by zoxide plugin |
| Zinit installed and sourced but loading **zero** plugins | dead weight + a second compinit path | removed entirely (.zshrc and setup.sh) |
| `skip_global_compinit=1` set in `environment.zsh` | no-op (must be set before zsh init, e.g. `.zshenv`) | removed |

### 🟡 Correctness / hygiene

- **`setopt NULL_GLOB` globally is dangerous** — an unmatched glob is silently
  removed from the command line, so e.g. `rm *.bak` in a directory with no
  `.bak` files becomes plain `rm` instead of an error. Removed.
- **Hardcoded `/Users/emilramsvik/.bun/_bun`** in `.zshrc` → `$HOME`.
- **`echo "✓ ..."` in every module** — output during startup breaks
  `scp`/`sftp`/`rsync` to the machine and prompt-toolkit tools, and adds noise.
  All removed.
- **Duplicate bun PATH setup** in both `.zshrc` and `environment.zsh` → kept
  once, in `environment.zsh`.
- `zstyle matcher-list` was defined twice in `settings.zsh` → deduped.
- `.zshrc.bak`, `false`, `setup.sh-e` are stray files at the repo root
  (left as-is; consider deleting).

---

## 2. What popular configs on GitHub converge on (research)

Looked at currently popular setups (omerxx/dotfiles, typecraft-dev/dotfiles,
driesvints/dotfiles, the classic mathiasbynens/holman repos) and 2025/2026
community writeups. The consensus stack:

| Area | Consensus | Status of what we had |
|---|---|---|
| Prompt | **Starship** (Rust, TOML config, custom hex palettes). Powerlevel10k is officially on life support — author states no new features and no bugfixes ([romkatv/powerlevel10k#2690](https://github.com/romkatv/powerlevel10k/issues/2690)) | `robbyrussell` (fine, but no git status detail, no brand colors) |
| cd | **zoxide** (`z <dir>`, frecency ranking, ~5ms init) | autojump — unmaintained, ~50ms init |
| Command correction | thefuck is dead (no release since Jan 2022, breaks on Python 3.12+). Successor: [pay-respects](https://github.com/iffse/pay-respects) | thefuck |
| Fuzzy find | **fzf** + **fzf-tab** (tab completion through a fuzzy picker) | none |
| ls / cat / find / grep | **eza / bat / fd / ripgrep** (note: exa is archived; eza is the maintained fork) | stock BSD tools |
| Suggestions & highlighting | zsh-autosuggestions + zsh-syntax-highlighting (loaded last) | listed but not loading |
| History | atuin (SQLite-backed, optional sync) — *not adopted here, see §5* | zsh defaults (well-tuned already) |

The minority trend is dropping OMZ entirely for zinit/antidote + 4 plugins.
**Not recommended here** — the OMZ plugin set in use (git, docker, macos,
terraform aliases/completions) is exactly what OMZ is good at, and with lazy
nvm + single compinit the startup cost is fine.

## 3. Changes made

### Shell (`.zshrc`, `zsh/*.zsh`)

1. **Load order fixed**: environment → plugins array → oh-my-zsh → settings →
   functions → aliases → local → starship init.
2. **Plugins now actually load**, with additions:
   `fzf` (Ctrl+R fuzzy history, Ctrl+T file picker, Alt+C fuzzy cd),
   `zoxide` (`z proj` jumps to your most-used dir matching "proj"),
   `fzf-tab` (tab completion becomes a fuzzy picker with directory previews),
   `nvm` (lazy), `zsh-completions` (extra completion defs on fpath).
3. **Removed**: thefuck, autojump, zinit.
4. **Modern CLI aliases** (all guarded with `command -v`, so nothing breaks
   before `brew bundle`): `l`/`ll`/`la`/`lt` → eza with icons + git status,
   `cat` → bat (plain `cat` still available as `catp`), bat as `MANPAGER` for
   colored man pages.
5. `zsh-syntax-highlighting` and autosuggestion colors restyled to the brand
   palette (commands = Gul, paths = Blå, substitutions = Oransje, errors =
   coral, strings = sage).

### Style (the brand palette, everywhere)

- **`ghostty/themes/systek-dark`** — a full 16-color Ghostty theme:
  background Grå `#1A1A1A`, foreground Off-white `#FCF6EE`, cursor Oransje,
  yellow slot = Gul, blue slot = Blå, bright-red slot = Oransje. Red, green,
  magenta and cyan are derived (coral `#E5604C`, sage `#A9C47F`, dusty rose
  `#D9A0C7`, soft teal `#7EC9BE`) since a usable ANSI palette needs all 16
  slots — they're warmed to sit naturally next to the brand hues.
- **`ghostty/config`** — activates the theme, JetBrains Mono Nerd Font,
  window padding, subtle transparency + blur, block cursor, tabs titlebar.
- **`starship.toml`** — prompt in the same palette: directory in Blå, git
  branch in Oransje, git status in Gul, `❯` in Oransje (coral on error),
  command duration shown when > 2s, python/node/terraform/docker context only
  when relevant.
- **fzf** picker colors match the palette too (`FZF_DEFAULT_OPTS`).

### Install (`Brewfile`, `setup.sh`)

- Brewfile: `+ starship zoxide fzf eza bat fd ripgrep font-jetbrains-mono-nerd-font`,
  `- autojump thefuck zsh-syntax-highlighting` (the latter now comes from
  `$ZSH_CUSTOM`).
- setup.sh: clones the four custom plugins into `$ZSH_CUSTOM/plugins`,
  symlinks `ghostty/` and `starship.toml` into `~/.config`, zinit installer
  removed.

## 4. How to roll it out on your Mac

```bash
cd ~/dotfiles && git pull
brew bundle                      # installs starship, zoxide, fzf, eza, bat, fd, rg, nerd font
./setup.sh                       # or just run the clone_omz_plugin/symlink parts
zoxide import --from=autojump    # keep your autojump directory rankings
brew uninstall autojump thefuck  # optional cleanup
exec zsh                         # restart the shell; cmd+shift+, in Ghostty to reload theme
```

Sanity checks: `echo $plugins` should list everything; typing a command should
show yellow highlighting + gray ghost suggestions; `time zsh -i -c exit`
should land well under 0.5s.

## 5. Considered and *not* adopted (easy future upgrades)

- **atuin** — SQLite history with cross-machine sync. Your history settings
  are already good and fzf's Ctrl+R covers fuzzy search; add atuin later if
  you want history synced across machines (`eval "$(atuin init zsh)"` at the
  very bottom of `.zshrc`).
- **pay-respects** (thefuck successor) — `cargo install pay-respects`, then
  `eval "$(pay-respects zsh --alias)"`. Left out to keep startup lean; add if
  you actually miss `fuck`.
- **fnm or mise instead of nvm** — even with lazy loading, the first
  `node`/`npm` call in a shell pays nvm's ~500ms. fnm is a drop-in Rust
  replacement (~ms, reads `.nvmrc`).
- **fast-syntax-highlighting** — richer/faster than zsh-syntax-highlighting,
  but the stock one is more battle-tested with OMZ; revisit if highlighting
  ever feels laggy.
- **Dropping OMZ for zinit/antidote** — ~50–120ms startups are possible, but
  you'd re-implement the git/docker/macos plugin conveniences by hand.
