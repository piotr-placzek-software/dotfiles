#!/usr/bin/env bash
set -euo pipefail

# 🪪 bashrc / aliases
profile_file="$HOME/.bashrc"
[ -f "$HOME/.bash_profile" ] && profile_file="$HOME/.bash_profile"

# Lines to add to source .bash_aliases and .bashrc_custom
source_lines=$(cat <<EOF

# Load custom aliases
if [ -f ~/.bash_aliases ]; then
  . ~/.bash_aliases
fi

# Load additional custom bash configuration
if [ -f ~/.bashrc_custom ]; then
  . ~/.bashrc_custom
fi

EOF
)

if ! grep -qF ".bash_aliases" "$profile_file"; then
  echo "🪪 Adding .bash_aliases and .bashrc_custom source lines to $profile_file"
  echo "$source_lines" >> "$profile_file"
else
  echo "🪪 Source lines for .bash_aliases already present in $profile_file, skipping"
fi 

echo "✅ Bash setup complete."
