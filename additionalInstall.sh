#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "This script forwards to setup.sh."
"$REPO_ROOT/setup.sh" "$@"
