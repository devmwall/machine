#!/usr/bin/env bash
# Adjust the focused output's scale by a relative step (e.g. +0.1 / -0.1),
# clamped to [0.5, 3.0]. Bound to $mod+plus / $mod+minus in the sway config.
set -euo pipefail

step="${1:?usage: scale.sh <+0.1|-0.1>}"

# Pick the focused output, falling back to the first active/first output.
read -r name scale < <(
    swaymsg -t get_outputs | jq -r \
        '(map(select(.focused)) + map(select(.active)) + .)[0] | "\(.name) \(.scale)"'
)

new=$(awk -v s="$scale" -v d="$step" \
    'BEGIN { v = s + d; if (v < 0.5) v = 0.5; if (v > 3.0) v = 3.0; printf "%.2f", v }')

swaymsg output "$name" scale "$new"
