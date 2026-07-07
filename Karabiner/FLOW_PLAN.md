# Karabiner Flow Improvement Plan

A reviewable plan for improving the keyboard flow defined in `Karabiner/karabiner.edn`
(compiled with [Goku](https://github.com/yqrashawn/GokuRakuJoudo)), plus a strategy for
getting Keyboard Maestro / Hammerspoon / AppleScript automations under version control.

> **Status: implemented** (all phases, in this branch). Decisions taken where the plan
> left a choice:
> - **#4** line start/end kept on `0`/`e` (`0` = start, vim-style — it previously meant
>   *end*); `q` freed, `1` now types `!` like the other numbers.
> - **#5** the symbol cluster lives on the **tab layer** (`h l j k n m` = `[ ] { } ( )`);
>   removed from caps. This also adds the previously missing `)`.
> - **#9** Hyper = hold right ⌘ (tap = right ⌘); app-specific right-⌘ rules still win in
>   Spotify/Chrome/VSCode.
> - **#10** window management moved to a `w` simlayer; the duplicate `m` binding on the
>   tab layer (maximize vs `)`) is resolved.
> - Extra fix found during implementation: the ⇧-selection rules (`!Sa`, `!Ss`, …) were
>   listed *after* the `##`-rules on the same keys, so caps+⇧+a/s never fired (the
>   optional-any rules matched first). Selection rules now come first.
> - The version-control section is implemented as `hammerspoon/init.lua`,
>   `scripts/export-km-macros.{sh,applescript}`, and `keyboard-maestro/`.

Each phase was designed so it can be reviewed (and reverted) independently.

---

## Current state (what the config does today)

| Layer | Trigger | Purpose |
|---|---|---|
| `caps-mode` | hold Caps Lock (tap = Esc) | vim-style navigation, selection, copy/paste, symbol insertion |
| `tab-mode` | hold Tab (tap = Tab) | Rectangle window management, brackets, misc app macros |
| `q-mode` (simlayer) | hold `q` | App launcher via Keyboard Maestro `open:` macros |
| Spotify rules | media keys | Spotify control via `osascript` |
| `right_command` | app-specific | ⌘L in Spotify/Chrome, ⌘P in VS Code |
| Quit guard | ⌘Q twice | prevents accidental quit |

Supporting infra: `setup.sh` symlinks `karabiner.edn` → `~/.config/karabiner.edn` and runs `goku`.

---

## Phase 1 — Correctness & cleanup (no behavior redesign)

Low-risk fixes that make the config trustworthy before adding anything new.

1. **Remove the dead `caps-command-mode` layer.**
   `:layers` defines both `:caps-mode` and `:caps-command-mode` on the *same key*
   (`:caps_lock`). Only `caps-mode` is ever referenced. The second definition is dead
   config at best and a conflict at worst — delete it (or actually adopt it, see Phase 3).

2. **Fix the double undo: make `r` redo.**
   Both `[:##u :!Cz]` and `[:##r :!Cz]` map to undo. Vim muscle memory says `r`/`ctrl-r`
   is redo → change to `[:##r :!CSz]` (⌘⇧Z).

3. **Fix wrong/copy-pasted comments.**
   - Tab layer: `q/w/e/r/t` are all commented as thirds, with `r` and `t` both saying
     "Right third" — document what `:!OTe` and `:!OTt` actually do in Rectangle.
   - Caps layer numbers: the comment says "NUMBER KEYS ARE SHIFT + NUMBER" but `1` and `0`
     are actually line-start/line-end. Split the comment so it matches reality.
   - `[:##h :##left_arrow]` carries the "## means…" legend inline; the legend already
     exists at the bottom of the file.

4. **Deduplicate line-start/line-end bindings.**
   `q`/`1` are both start-of-line (`⌘←`) and `e`/`0` are both end-of-line (`⌘→`).
   Keep one pair (suggestion: keep `0`/`e` — vim `0` and `e` are natural) and free the
   other keys for something new, or consciously keep both and document why.

5. **Resolve the duplicated symbol cluster.**
   Brackets/braces/parens exist on *both* layers with *different* fingers:
   - caps: `n`=`[` `.`=`]` `m`={ `,`=} `;`=(
   - tab:  `h`=`[` `l`=`]` `j`={ `k`=} `n`=( `m`=)
   Two different muscle-memory maps for the same symbols is anti-flow. Pick one home
   (suggestion: a dedicated symbols cluster on the tab layer, since caps is "movement")
   and remove the other. Also note caps has `(` but no `)` today.

6. **Repo hygiene.**
   - Add `Karabiner/karabiner/automatic_backups/` to `.gitignore` and remove the two
     checked-in backups.
   - The checked-in `Karabiner/karabiner/karabiner.json` is stale (it only contains an
     old single "capskey" rule — nothing like the current edn). Either delete it and
     treat the edn as the single source of truth, or wire it up properly (Phase 4) so the
     committed json is always the freshly compiled output.

## Phase 2 — Reduce external dependencies

7. **Launch apps directly instead of round-tripping through Keyboard Maestro.**
   The `q-mode` launcher calls KM macros that just open apps. The edn already defines an
   `:open` template — use it and the KM dependency for launching disappears:
   ```clojure
   [:j [:open "-a Zed"]]         ; instead of [:km "open: ..."]
   ```
   (Template becomes `:open "open %s"` so `-a` works, or add an `:app "open -a '%s'"`
   template.) Keep `:km` only for macros that do real KM work (clipboard-to-inbox,
   TomatoBar).

8. **Consider replacing per-app Spotify AppleScript with generic media keys** only if the
   Spotify-specific behavior isn't needed — otherwise keep as-is, it works.

## Phase 3 — Flow upgrades (new capability)

9. **Add a proper Hyper key.**
   Reuse the deleted `caps-command-mode` idea: caps-hold already taken, so put Hyper
   (⌘⌃⌥⇧, goku `:!!`) on `right_command`-hold or `tab`+`caps` combo. Hyper gives every
   app a private, conflict-free hotkey namespace — this is the hook Hammerspoon/KM
   bindings should hang off later.

10. **Window management on its own simlayer (`w-mode`), freeing the tab layer.**
    Tab-hold currently mixes Rectangle, symbols, and KM macros. A `w`-simlayer with
    mnemonic directions (`h/l` halves, `m` maximize, `q/w/e` thirds) keeps one theme per
    layer: caps = move text, w = move windows, q = open apps.

11. **Add the missing text-flow verbs to caps-mode** (cheap wins, keys are free):
    - `f` — delete to end of line (`⌘→` then select-delete) or "cut line"
    - `g` / `:!Sg` — top/bottom of document (`⌘↑` / `⌘↓`), mirroring vim `gg`/`G`
    - `t` — tab-switch (`⌃Tab`) for in-app tab flow
    - `[:!Sd ...]` — delete without the triple-chord currently on `d`

12. **App-specific layers** — extend the existing `right_command` idea: same physical key,
    per-app meaning (`:spotify`/`:chrome`/`:vscode` conditions already declared).

## Phase 4 — Tooling & guardrails

13. **Run `goku` in watch mode as a service** so edits apply on save:
    `brew services start goku` (add a note to README + setup.sh).
14. **CI sanity check**: a GitHub Action that runs `goku --config Karabiner/karabiner.edn --dry-run`
    (via `brew install yqrashawn/goku/goku` on a macOS runner) so a broken edn can't merge —
    this repo has already had one "fix goku syntax errors" PR; CI would have caught it.
15. **Document the layer map in README.md** — a table like the one at the top of this file,
    kept next to the legend comments.

---

## Version-controlling Keyboard Maestro / Hammerspoon / AppleScript

Short answer: **yes, all three** — Hammerspoon is trivially version-controllable,
AppleScript is if you keep sources as text, and Keyboard Maestro needs a small export
script (which can itself be a KM macro or cron job).

### Hammerspoon — config *is* code (best fit for this repo)
Hammerspoon reads `~/.hammerspoon/init.lua`. Manage it exactly like `karabiner.edn`:

```sh
# setup.sh
create_symlink "${DOTFILES_DIR}/hammerspoon" "${HOME}/.hammerspoon" "true"
```

Everything — window rules, hotkeys, URL handlers, `hs.execute` results — lives in Lua
files in the repo. Script output can be written to files with plain
`io.open(...):write(...)` or `hs.json.encode`. If Karabiner + Hammerspoon grow together,
the Hyper key from Phase 3 is the natural bridge (Karabiner produces Hyper, Hammerspoon
consumes it).

### AppleScript — keep sources as text, run with `osascript`
- Store scripts as plain-text `.applescript` files in the repo (not compiled `.scpt`,
  which is binary and diffs badly). Decompile existing ones once: `osadecompile foo.scpt > foo.applescript`.
- Run and capture results as files:
  ```sh
  osascript scripts/spotify-now-playing.applescript > output/now-playing.txt
  ```
  `osascript` prints the script's return value to stdout, so redirecting to a file is all
  it takes. JXA works the same way: `osascript -l JavaScript file.js`.
- The Karabiner shell templates (`:km`, Spotify rules) already do this pattern inline —
  longer scripts can move into `scripts/*.applescript` and be called from the edn, which
  makes them diffable and reusable.

### Keyboard Maestro — export macros to XML on a schedule
KM stores macros in `~/Library/Application Support/Keyboard Maestro/Keyboard Maestro Macros.plist`
(binary, changes constantly — don't commit it raw). Two workable approaches:

1. **AppleScript export (recommended).** KM's AppleScript dictionary exposes macro groups
   and each group/macro has an `xml` property, so a script can dump every group to a
   diffable `.kmmacros` file:
   ```applescript
   tell application "Keyboard Maestro"
     repeat with g in macro groups
       set xmlText to xml of g
       -- write xmlText to dotfiles/keyboard-maestro/<group name>.kmmacros
     end repeat
   end tell
   ```
   `.kmmacros` files are XML plists → readable diffs, and re-importable by double-click.
2. **Plist snapshot (fallback).** Copy the plist and convert to XML for diffing:
   ```sh
   plutil -convert xml1 -o keyboard-maestro/macros-backup.xml \
     "$HOME/Library/Application Support/Keyboard Maestro/Keyboard Maestro Macros.plist"
   ```
   Simple, but one giant file including UUID/usage-counter churn — noisier diffs than #1.

**Automating the commit:** wrap either approach in a script
(`scripts/export-km-macros.sh`) that exports and then `git add && git commit` when the
output changed. Trigger it from a KM macro on a timer, a `launchd` job, or a cron entry —
KM can even run it whenever macros are edited (trigger: "Engine launches" + periodic).

### Suggested repo layout

```
dotfiles/
├── Karabiner/karabiner.edn         # existing (source of truth)
├── hammerspoon/init.lua            # symlinked to ~/.hammerspoon
├── keyboard-maestro/*.kmmacros     # exported XML, one file per macro group
└── scripts/
    ├── export-km-macros.sh         # export + auto-commit
    └── *.applescript               # plain-text AppleScript sources
```

---

## Suggested review order

1. Phase 1 (pure cleanup) — smallest diff, decide the symbol-layer question (#5).
2. Phase 2 #7 — drop KM from the launcher, or veto if KM's `open:` macros do more than `open -a`.
3. Phase 3 — pick which upgrades are wanted (Hyper key first; it unblocks the Hammerspoon bridge).
4. Phase 4 + the version-control section — infra, independent of the keymap itself.
