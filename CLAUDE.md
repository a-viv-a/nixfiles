# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a NixOS configuration repository using flakes for a laptop named "blade". The configuration includes:
- Impermanence setup (root filesystem is tmpfs, only `/nix/persist` survives reboots)
- Home-manager for user environment management
- Secrets management via sops-nix
- River (Wayland compositor) window manager
- Custom fish shell configuration with functions and completions

## Architecture

### Flake Structure (`flake.nix`)

The main entry point defines a single NixOS configuration (`blade`) that imports:
- `configuration.nix` - System-level config
- `home.nix` - User environment config (via home-manager)
- `wm.nix` - Window manager (River) configuration
- `laptop.nix` - Laptop-specific settings (power management, Bluetooth)
- `greetd.nix` - Login manager
- `dict.nix` - Dictionary services
- `persist.nix` - Impermanence configuration

A custom rustbin overlay is passed via `specialArgs` from `rustbin/flake.nix`.

### Impermanence (`persist.nix`)

Root filesystem is tmpfs. Only `/nix/persist` survives reboots. Critical directories/files are explicitly persisted:
- System: `/var/log`, `/var/lib/systemd`, NetworkManager connections, etc.
- User (`~aviva`): Config directories (`.ssh`, `.config/sops/`, `.claude`), data (repos, documents, downloads), and application state

**Important**: When adding new config files or state, check if they need to be added to `persist.nix`.

### Home Manager (`home.nix`)

User environment is declaratively configured:
- Programs: helix (default editor), fish shell, git, zoxide, direnv, claude-code
- Config files are linked via `xdg.configFile.*` (for `~/.config/*`) or `home.file.*` (for other `~/*` paths)
- External config directories (fish/functions, river, fuzzel, foot, halloy) are sourced from subdirectories in this repo

**Pattern**: Configuration files are stored in subdirectories (e.g., `./fish/functions/`, `./river/`), then linked into place using `xdg.configFile` or `home.file`.

### Secrets Management

- Secrets stored in separate private repo (`a-viv-a/secrets_nix`)
- Decrypted at runtime using sops-nix with age keys at `/nix/persist/home/aviva/.config/sops/age/keys.txt`
- SSH key at `/nix/persist/home/aviva/.ssh/id_ed25519` used for sops

## Common Commands

### Building and Switching

```bash
# Rebuild system configuration (apply changes)
sudo nixos-rebuild switch --flake .#blade

# Build without switching (test build)
sudo nixos-rebuild build --flake .#blade

# Build and switch home-manager only
home-manager switch --flake .#blade
```

### Updating Dependencies

```bash
# Update flake.lock
nix flake update

# Update specific input
nix flake update nixpkgs
```

### Garbage Collection

```bash
# Manual garbage collection
sudo nix-collect-garbage -d

# Note: Automatic GC runs weekly, deleting generations >60 days old
```

### Development

```bash
# Enter development shell from flake templates
nix develop  # Uses flake.nix in current directory

# Use project templates (./templates/*)
nix flake init -t ./templates/rust
nix flake init -t ./templates/zig
```

## River Window Manager Configuration

### Initialization (`river/init`)

The main River init script written in Fish shell that configures:

**Key Bindings:**
- Uses Canary keyboard layout by default (pass `querty` arg to switch)
- Movement keys: M/N/E/I (left/down/up/right) on Canary, H/J/K/L on QWERTY
- Super+T: spawn terminal (foot)
- Super+R: spawn launcher (fuzzel)
- Super+Backspace: close window
- Super+Space: toggle float
- Super+F: toggle fullscreen
- Super+directional: focus/swap windows
- Super+Comma/Period: adjust main ratio
- Media keys and Super+arrows: volume/brightness/playback control

**Tag System:**
- Custom modal tag selection using rise/fall key combos (Y/S/V for rise, P/T/D for fall)
- Tags 1-9 selected by combinations: rise key enters mode, fall key selects tag
- Scratchpad tags on Super+L (tag 10) and Super+P (tag 11)
- Default tags: vesktop on tag 9, Spotify on tag 8

**Hardware:**
- Configured for Logitech ERGO M575 mouse with custom acceleration/scroll settings
- Touchpad with tap-to-click, natural scroll, disable-while-typing

**Layout:**
- Uses `rivercarro` as layout manager
- Spawns status bar (`./river/status`) and bar display (`./river/bar`)

### Status Bar (`river/status`)

Complex generator-based status system written in Fish that updates sandbar via FIFO pipe.

**Architecture:**
- Each widget is a generator function (`{name}_fn`) with associated period and output variables
- Main loop ticks every `min_period` seconds (60s by default)
- Widgets can be refreshed asynchronously via files in `$XDG_RUNTIME_DIR/status_needs_refresh/`

**Widgets** (left to right in status bar):
1. `player` - Current media from playerctl (async watcher, no period)
2. `weather` - wttr.in weather (30min period, backs off on errors/offline)
3. `audio` - Volume level and mute status (refresh on keyboard shortcut)
4. `wifi` - SSID and signal strength (120s period, expensive)
5. `brightness` - Screen brightness percentage (240s period)
6. `memory` - RAM usage with sparkline graph (15s period)
7. `cpu` - Load average with sparkline graph (15s period)
8. `power` - Battery % with discharge watts, time remaining estimate, and watts graph (15s period)
9. `datetime` - Current date/time (60s period)

**Adding New Widgets:**
1. Add widget name to `set names` list at top of file
2. Create `{name}_out` and `{name}_period` variables
3. Implement `{name}_fn` function to generate widget output
4. Add `${name}_out` to `write_display` function in desired position
5. Use `^fg(color)[content]` format for colored output (sandbar markup)
6. Set period to `-1` for event-driven widgets

**Async Refresh Pattern:**
Fish functions can write to `$needs_refresh_dir/{name}` to trigger widget updates outside normal periods. Used for expensive computations and external events.

### Bar Display (`river/bar`)

Spawns sandbar process that reads from FIFO and renders the status bar.

**Configuration:**
- Bottom placement (`-bottom`)
- Custom colors matching fish theme variables
- Iosevka Nerd Font
- 11 tags: scratch tags (sl=10, sp=11) plus normal tags (1-9)
- Active/inactive/urgent tag colors coordinated with River border colors

**Modifying Appearance:**
Edit `river/bar` sandbar flags for colors/fonts/positioning.

## Important Notes

- Users have immutable passwords (managed via sops, `users.mutableUsers = false`)
- The `.claude` directory is persisted in impermanence config
- Fish shell functions/completions are in `./fish/functions/` and `./fish/completions/`
- Window manager config scripts are in `./river/`
- When adding new applications, consider if their state/config needs persistence
- System uses `nixos-unstable` channel
- Fish color variables (`$fish_color_*`) are used throughout River/sandbar configs for theming
