#!/usr/bin/env bash
set -euo pipefail

# 🔗 Dotfiles
if command -v stow &>/dev/null; then
  echo "🔗 Linking dotfiles..."
  cd "$(dirname "$0")/stow"
  for dir in */; do
    stow "$dir" -t "$HOME"
  done
fi

echo "✅ Dotfiles setup complete."
