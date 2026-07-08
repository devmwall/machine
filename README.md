 Machine Setup

## Ubuntu (sway)

For a fresh Ubuntu install using sway:

```
./setup-ubuntu.sh
```

Run it as your normal user (it uses `sudo` internally). It:
- installs **sway** + Wayland essentials, and **VSCode** (from Microsoft's apt repo)
- installs the sway config (`env/.config/sway/config`) and VSCode settings
- adds a **git-aware bash prompt** so you see the current branch when you `cd` into a repo

The built-in terminal (**ptyxis**) is used as-is. Log out and pick "Sway" at the
login screen, then open a new terminal to get the git prompt.

## Fedora / Arch Setup Instructions

1. Set the DEV_ENV environment variable to the path of this repository
   ```
   export DEV_ENV=/path/to/this/repo
   ```

2. Run `sudo ./setup.sh` to install packages and configure system

3. Run `./backup_configs.sh` to update configs in the repository

### Requirements
- Sudo access
- Fedora Linux
- DEV_ENV environment variable set

### Included Configurations
- i3 Window Manager
- Neovim
- VSCode
- Tmux
EOF

# Make scripts executable
chmod +x setup.sh
chmod +x backup_configs.sh

echo "Machine setup scripts and configs created successfully!"