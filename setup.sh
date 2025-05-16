#!/usr/bin/env bash
set -euo pipefail

SKIP_DEPS=0
SKIP_TOOLS=0
SKIP_DOTFILES=0
SKIP_BASH=0

for arg in "$@"; do
  case "$arg" in
    skip-deps) SKIP_DEPS=1 ;;
    skip-tools) SKIP_TOOLS=1 ;;
    skip-dotfiles) SKIP_DOTFLIES=1 ;;
    skip-bash) SKIP_BASH=1 ;;
    *) echo "❌ Unknown argument: $arg" >&2; exit 1 ;;
  esac
done

run_script() {
  local script_name=$1
  local skip_flag=$2

  if [[ $skip_flag -eq 1 ]]; then
    echo "⏭  Skipping $script_name.sh"
    return
  fi

  if [[ -x "./$script_name.sh" ]]; then
    echo "▶️  Staring script $script_name.sh..."
      "./$script_name.sh"
  else
    echo "⚠️  Missing $script_name.sh or is not executable" >&2
  fi
}

run_script "dependencies"  "$SKIP_DEPS"
run_script "tools" "$SKIP_TOOLS"
run_script "dotfiles" "$SKIP_DOTFILES"
run_script "bash"  "$SKIP_BASH"

echo "✅ Setup complete"

