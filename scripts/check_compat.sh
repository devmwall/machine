#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

echo "Checking for Arch-only assumptions..."
if rg -n --glob '!scripts/check_compat.sh' \
  '\bpacman\b|\bparu\b|\byay\b|/etc/pacman\.d|mkinitcpio|makepkg|yaourt|\bAUR\b|reflector' \
  setup.sh additionalInstall.sh config.sh backup_configs.sh scripts; then
  echo "Compatibility check failed: Arch-specific terms found."
  exit 1
fi

echo "Checking for hardcoded /home paths in bootstrap scripts..."
if rg -n --glob '!scripts/check_compat.sh' '/home/' \
  setup.sh additionalInstall.sh config.sh backup_configs.sh scripts; then
  echo "Compatibility check failed: hardcoded /home path found."
  exit 1
fi

echo "Compatibility check passed."
