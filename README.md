# Machine Setup

## Quick Start

1. Install the minimal code environment and apply config:
   ```bash
   ./setup.sh
   ```
2. Apply dotfiles/config only:
   ```bash
   ./config.sh
   ```
3. Back up local config changes back into repo:
   ```bash
   ./backup_configs.sh
   ```

## Script Layout

- `setup.sh`: installs Ubuntu dev tooling, Go, Hyprland, Waybar, VS Code, Neovim, Opencode, then applies config.
- `scripts/apply-config.sh`: syncs repo config into user home.
- `backup_configs.sh`: syncs local config back into the repo.
