 Fedora Machine Setup

## Setup Instructions

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