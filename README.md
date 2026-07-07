# Dotfiles

Personal configuration files for macOS/Linux development environment.

## Prerequisites

Before running the setup script, ensure you have:

- **macOS** (tested on recent versions) or **Linux**
- **Zsh** installed (usually pre-installed on macOS)
- **Git** installed
- **curl** installed (usually pre-installed)
- **Internet connection** for downloading packages and tools
- **Administrator access** (for Homebrew installation)

## Installation

1. Navigate to your home directory:
   ```bash
   cd ~
   ```

2. Clone this repository:
   ```bash
   git clone https://github.com/EmilRamsvik/dotfiles.git
   ```

3. Navigate to the dotfiles directory:
   ```bash
   cd dotfiles
   ```

4. Run the setup script:
   ```bash
   ./setup.sh
   ```

## What Gets Installed

The setup script will:

- ✅ Install **Homebrew** (if not already installed)
- ✅ Install packages from **Brewfile** (including Karabiner-Elements, Goku, etc.)
- ✅ Install **Oh-My-Zsh** for enhanced shell experience
- ✅ Install **Zinit** plugin manager for Zsh
- ✅ Create symbolic links for:
  - `.zshrc` - Zsh configuration
  - `.gitconfig` - Git configuration
  - `karabiner.edn` - Karabiner-Elements keyboard mappings
  - `hammerspoon/` - Hammerspoon configuration (`~/.hammerspoon`)
  - Zed editor settings and keymaps
- ✅ Create project folder structure in `~/Documents`
- ✅ Configure Karabiner-Elements using Goku (and start `goku` in watch mode via `brew services`, so edits to `karabiner.edn` apply on save)

## Directory Structure

After installation, the following directories will be created:

```
~/Documents/
├── dev/         # Development projects
├── notebooks/   # Jupyter notebooks or notes
├── admin/       # Administrative files
└── projects/    # General projects
```

## Configuration Files

- **`.zshrc`** - Zsh shell configuration
- **`gitconfig`** - Git global configuration
- **`Brewfile`** - Homebrew packages list
- **`Karabiner/karabiner.edn`** - Keyboard mappings (source of truth; compiled by Goku)
- **`hammerspoon/`** - Hammerspoon (Lua) automation config
- **`keyboard-maestro/`** - Exported Keyboard Maestro macros (see `scripts/export-km-macros.sh`)
- **`scripts/`** - Helper scripts and plain-text AppleScript sources
- **`zed/`** - Zed editor configuration

## Keyboard layers (Karabiner)

Defined in `Karabiner/karabiner.edn`, compiled with [Goku](https://github.com/yqrashawn/GokuRakuJoudo). A `karabiner.edn` change is applied automatically when the goku watch service is running (`brew services start goku`), and validated in CI by `.github/workflows/karabiner-check.yml`.

| Layer | Trigger | Purpose |
|---|---|---|
| Caps layer | hold Caps Lock (tap = Esc) | vim-style navigation, selection, editing; `0`/`e` = line start/end, `g`/`⇧g` = document top/bottom, `t`/`⇧t` = next/prev tab, `u`/`r` = undo/redo |
| Tab layer | hold Tab (tap = Tab) | symbols (`h l j k n m` = `[ ] { } ( )`); `i`/`o` trigger Hammerspoon inbox/pomodoro |
| `w`-layer | hold `w` + key | Rectangle window management (`h/l/j/k` halves, `m` maximize, `u/i/o` thirds, `y/p` two-thirds, `c` center) |
| `q`-layer | hold `q` + key | app launcher via `open -a` |
| Hyper | hold right ⌘ (tap = right ⌘) | ⌘⌃⌥⇧ — private hotkey namespace for Hammerspoon/Keyboard Maestro |

Note: `q`- and `w`-layers are simultaneous-key layers ("simlayers"). If holding-a-letter ever misfires while typing fast, add a lower `:simlayer-threshold` (milliseconds) at the top level of `karabiner.edn`.

## Hammerspoon

Config lives in `hammerspoon/`, symlinked to `~/.hammerspoon` — one module per automation, machine-specific settings (paths, app names, URL routes) in `hammerspoon/config.lua`. Hyper+R reloads; the config also reloads itself when a `.lua` file changes.

| Module | Binding | What it does |
|---|---|---|
| `apps.lua` | hyper + letter | focus-or-hide app toggles (letters mirror the q-layer: `j` Zed, `l` Ghostty, `w` Slack, `g` Chrome, …) |
| `search.lua` | hyper+`b` | Spotlight-style Google search / open-URL prompt (port of `autohotkey/google_search.ahk`) |
| `spotify.lua` | hyper+`space`, hyper+`←`/`→` | now-playing HUD, previous/next track |
| `inbox.lua` | hyper+`i` (also Karabiner tab+`i`) | append clipboard with timestamp + source app to the Obsidian inbox note (replaces the KM macro) |
| `pomodoro.lua` | hyper+`p` (also Karabiner tab+`o`) | menubar pomodoro timer (replaces TomatoBar) |
| `urls.lua` | automatic | URL dispatcher: Hammerspoon becomes the system default browser and routes links — everything opens in Google Chrome unless a domain rule in `config.lua` says otherwise. macOS asks once to confirm the handoff. |
| `layouts.lua` | hyper+`1`/`2` + automatic | coding / communication window layouts; auto-applies coding layout when an external monitor connects and maximizes everything on disconnect |

## Automation under version control
- **AppleScript**: keep sources as plain-text `.applescript` files in `scripts/` (not binary `.scpt`). Run and capture output with `osascript scripts/foo.applescript > result.txt`.
- **Keyboard Maestro**: run `scripts/export-km-macros.sh` to export every macro group as a diffable `.kmmacros` XML file into `keyboard-maestro/` and auto-commit changes. Trigger it from a KM macro on a timer or a `launchd`/cron job to keep it current.

## Troubleshooting

### Setup script fails immediately

**Issue**: Script exits with error about undefined variables or command failures

**Solution**: The script uses strict error checking (`set -e`, `set -u`, `set -o pipefail`). Check the error message for:
- Missing required commands (ensure curl, git are installed)
- Network connectivity issues
- Permission problems

### Homebrew installation fails

**Issue**: Homebrew doesn't install or configure correctly

**Solution**:
- Ensure you have administrator/sudo access
- Check your internet connection
- Manually install Homebrew first:
  ```bash
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  ```
- Run the setup script again

### Symbolic links already exist

**Issue**: Warning messages about existing configuration files

**Solution**:
- The script will prompt you to replace existing files
- Choose 'y' to replace or 'n' to keep existing files
- For `.gitconfig`, manual confirmation is required to avoid overwriting personal settings

### Oh-My-Zsh conflicts

**Issue**: Oh-My-Zsh installation interferes with existing setup

**Solution**:
- The script uses `--unattended` flag to prevent shell switching
- Your custom `.zshrc` will be symlinked after Oh-My-Zsh installation
- To manually reinstall: `rm -rf ~/.oh-my-zsh` and run setup again

### Karabiner-Elements not working

**Issue**: Keyboard mappings don't apply

**Solution**:
1. Ensure Karabiner-Elements is installed: `brew list karabiner-elements`
2. Grant necessary permissions in System Settings → Privacy & Security
3. Run Goku manually: `goku`
4. Check the goku watch service is running: `brew services list | grep goku`
5. Check Karabiner-Elements app for any error messages

### Permission denied errors

**Issue**: Cannot create directories or symbolic links

**Solution**:
- Ensure you have write permissions to `~/.config` and home directory
- Check if files are locked or in use by other applications
- Run: `chmod +x setup.sh` if script is not executable

### Zed editor configuration not applied

**Issue**: Zed settings don't appear

**Solution**:
- Ensure Zed is installed via Homebrew: `brew install zed`
- Check that `~/.config/zed/` directory exists
- Verify symbolic links: `ls -la ~/.config/zed/`
- Restart Zed editor

### Path issues after installation

**Issue**: Commands like `brew` not found after installation

**Solution**:
- Restart your terminal or run: `source ~/.zprofile`
- Check that Homebrew is in your PATH: `echo $PATH`
- For Apple Silicon Macs, ensure `/opt/homebrew/bin` is in PATH
- For Intel Macs, ensure `/usr/local/bin` is in PATH

## Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull origin main
./setup.sh
```

## Customization

- Edit `.zshrc` for shell customization
- Modify `Brewfile` to add/remove packages
- Update `Karabiner/karabiner.edn` for custom keyboard mappings
- Configure Zed settings in `zed/settings.json`

## Uninstalling

To remove symbolic links:

```bash
rm ~/.zshrc
rm ~/.gitconfig
rm ~/.config/karabiner.edn
rm -rf ~/.config/zed
```

Note: This does not uninstall Homebrew or installed packages.

## Contributing

This is a personal dotfiles repository, but feel free to fork and adapt for your own use.

## License

MIT License - feel free to use and modify as needed.
