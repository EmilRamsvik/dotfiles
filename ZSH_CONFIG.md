# ZSH Configuration Guide

## Overview

The ZSH configuration is organized into modular files for better maintainability and clarity. Each module handles a specific aspect of the shell configuration.

## File Structure

```
dotfiles/
├── .zshrc                    # Main configuration file
└── zsh/                      # Modular configuration directory
    ├── alias.zsh            # Shell aliases and shortcuts
    ├── environment.zsh      # PATH and environment variables
    ├── functions.zsh        # Custom shell functions
    ├── plugins.zsh          # Oh-My-Zsh plugins configuration
    ├── settings.zsh         # Shell behavior and settings
    └── local.zsh            # Local machine-specific overrides (not tracked)
```

## Module Descriptions

### `.zshrc` (Main Configuration)

The main entry point that:
- Initializes Oh-My-Zsh
- Sources all modular configuration files in the correct order
- Loads Zinit plugin manager

**Loading Order:**
1. `environment.zsh` - Sets up PATH and environment variables
2. `settings.zsh` - Configures shell behavior
3. `plugins.zsh` - Loads Oh-My-Zsh plugins
4. `functions.zsh` - Defines custom functions
5. `alias.zsh` - Sets up aliases
6. `local.zsh` - Machine-specific overrides

### `alias.zsh` (Aliases)

Organized categories of aliases:

#### Navigation
- `u`, `uu`, `uuu` - Navigate up directories
- `dev`, `nb`, `admin`, `p` - Jump to common directories
- `dot` - Navigate to dotfiles directory

#### Git Shortcuts
- `g` - git
- `gs` - git status
- `ga` - git add
- `gc` - git commit
- `gp` - git push
- `lg` - lazygit

#### Ollama (AI)
- `ol` - ollama command
- `olrun` - ollama run
- `ollist` - ollama list
- `olps` - ollama ps (show running models)

#### File Operations
- `l`, `ll`, `la` - Various ls variations
- `lsd` - List only directories
- `path` - Copy current path to clipboard

#### Docker
- `d` - docker
- `dc` - docker-compose
- `dps` - docker ps
- `dex` - docker exec -it

#### System
- `reload` - Reload shell configuration
- `myip` - Show public IP address
- `localip` - Show local IP address

### `functions.zsh` (Custom Functions)

#### Development Environment
- `venv [version]` - Create and activate Python virtual environment
- `va` - Activate existing virtual environment
- `pyinit <name>` - Initialize Python project with structure
- `jsinit <name>` - Initialize Node.js project with structure

#### Directory Management
- `mc <name>` - Make directory and cd into it
- `move <file>` - Move file to directory with same basename
- `extract <archive>` - Extract various archive formats

#### Git Helpers
- `gnb <branch>` - Create new git branch and switch to it
- `gq "message"` - Quick commit (add all + commit)

#### Ollama Helpers
- `olc <model> [prompt]` - Quick chat with Ollama model
- `olpr <model>` - Pull and run Ollama model

#### Network
- `port <number>` - Find process using specific port
- `killport <number>` - Kill process on specific port

#### Editors
- `v [path]` - Open VS Code
- `c [path]` - Open Cursor

### `environment.zsh` (Environment Variables)

Configures:
- **PATH** for various programming languages (Python, Java, Node, Rust, Go)
- **Development tools** (Flutter, Dart, UV package manager)
- **Editor** preferences (EDITOR, VISUAL)
- **Shell tools** (autojump, thefuck)
- **Ollama** configuration (OLLAMA_HOST)
- **Cloud providers** (AWS, GCP)
- **History** settings (size, file location)

### `settings.zsh` (Shell Settings)

Configures:
- **Completion system** with case-insensitive matching
- **History** behavior (sharing, deduplication)
- **Directory navigation** (auto_cd, auto_pushd)
- **Globbing** patterns
- **Key bindings** (Ctrl+Z, arrow keys, Ctrl+Left/Right)
- **Command correction**

### `plugins.zsh` (Plugins)

Loads Oh-My-Zsh plugins:
- `git` - Git integration
- `docker` - Docker completion
- `python`, `pip` - Python tools
- `node`, `npm` - Node.js tools
- `terraform` - Terraform completion
- `zsh-autosuggestions` - Command suggestions
- `thefuck` - Command correction
- `autojump` - Smart directory navigation
- `zsh-syntax-highlighting` - Syntax highlighting

### `local.zsh` (Local Overrides)

This file is for machine-specific settings that shouldn't be tracked in git:
- Local PATH additions
- Machine-specific aliases
- Private environment variables
- Company-specific configurations

## Usage Examples

### Ollama Examples

```bash
# List available models
ollist

# Run a model interactively
ol run llama3.2

# Quick chat with a model
olc llama3.2 "Write a Python function to sort a list"

# Pull and run a model
olpr codellama
```

### Python Development

```bash
# Create virtual environment with default Python
venv

# Create virtual environment with specific Python version
venv 3.11

# Activate existing virtual environment
va

# Initialize new Python project
pyinit my-project
# Creates: my-project/{src,tests,docs,README.md,requirements.txt,.gitignore}
```

### Git Workflow

```bash
# Create new branch
gnb feature/new-feature

# Quick commit
gq "Add new feature"

# View status and diff
gl

# Use lazygit for visual interface
lg
```

### Directory Navigation

```bash
# Navigate to dev directory
dev

# Go up two directories
uu

# Create and enter directory
mc new-folder

# Jump to frequently used directory (autojump)
j project-name
```

### Docker Shortcuts

```bash
# List running containers
dps

# Execute command in container
dex container-name bash

# View logs
dlog container-name
```

## Customization

### Adding Your Own Aliases

Edit `~/dotfiles/zsh/alias.zsh`:

```bash
# Add your alias
alias myalias="command"
```

### Adding Custom Functions

Edit `~/dotfiles/zsh/functions.zsh`:

```bash
my_function() {
  # Your function code
}
alias mf='my_function'
```

### Machine-Specific Settings

Edit `~/dotfiles/zsh/local.zsh` (not tracked in git):

```bash
# Work-specific settings
export WORK_PROJECT_DIR="$HOME/work/projects"
alias work="cd $WORK_PROJECT_DIR"

# Private tokens
export MY_PRIVATE_TOKEN="secret"
```

### Changing Default Editor

Edit `~/dotfiles/zsh/environment.zsh`:

```bash
export EDITOR="vim"  # or "code", "nano", etc.
export VISUAL="vim"
```

## Troubleshooting

### Reload Configuration

```bash
reload  # or: source ~/.zshrc
```

### Check Which File Defines a Command

```bash
which <command>
type <command>
```

### Debug Loading

Add to top of `.zshrc`:

```bash
zmodload zsh/zprof
```

Add to bottom of `.zshrc`:

```bash
zprof
```

### Plugin Not Working

1. Check if plugin is installed:
   ```bash
   ls ~/.oh-my-zsh/plugins/
   ```

2. For third-party plugins (zsh-autosuggestions, zsh-syntax-highlighting):
   ```bash
   brew list | grep zsh
   ```

3. Reinstall if needed:
   ```bash
   brew reinstall zsh-autosuggestions zsh-syntax-highlighting
   ```

## Performance Tips

1. **Lazy load heavy tools** - Move slow-loading tools to functions
2. **Profile startup time**:
   ```bash
   time zsh -i -c exit
   ```
3. **Disable unused plugins** in `plugins.zsh`
4. **Use Zinit** for faster plugin loading (already configured)

## Key Bindings Reference

| Key Combination | Action |
|----------------|--------|
| `Ctrl+Z` | Toggle suspend/resume |
| `↑` / `↓` | Search history by prefix |
| `Ctrl+Left` | Move word backward |
| `Ctrl+Right` | Move word forward |
| `Ctrl+Backspace` | Delete word backward |
| `Ctrl+R` | Reverse history search |
| `Tab` | Complete with menu |

## Updates and Maintenance

### Update Dotfiles

```bash
cd ~/dotfiles
git pull
reload
```

### Update Oh-My-Zsh

```bash
omz update
```

### Update Homebrew Packages

```bash
brew update && brew upgrade
```

## Resources

- [Oh-My-Zsh Documentation](https://github.com/ohmyzsh/ohmyzsh)
- [Zsh Manual](http://zsh.sourceforge.net/Doc/)
- [Zinit Documentation](https://github.com/zdharma-continuum/zinit)
- [Ollama Documentation](https://ollama.ai/docs)
