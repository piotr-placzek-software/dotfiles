#!/usr/bin/env bash
set -euo pipefail

FORCE=0
if [[ "${1:-}" == "--force" ]]; then
  FORCE=1
fi

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# 📦 Nix + Flakes
if ! command -v nix &>/dev/null; then
  echo "🔧 Installing Nix..."
  curl -L https://nixos.org/nix/install | sh
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

. "$HOME/.nix-profile/etc/profile.d/nix.sh"
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

nix profile install nixpkgs#jq nixpkgs#git nixpkgs#curl nixpkgs#go nixpkgs#make

# 🔨 Building form github sources
build_from_git() {
  repo="$1"
  name="$2"
  lang="$3"

  if [[ $FORCE -eq 0 ]] && (command -v "$name" &>/dev/null || [[ -x "$INSTALL_DIR/$name" ]]); then
    echo "🔍 $name already installed, skipping"
    return
  fi

  echo "🔨 Building $name from $repo ($lang)..."
  tmp=$(mktemp -d)
  git clone --depth 1 "https://github.com/$repo" "$tmp"
  pushd "$tmp" >/dev/null

  case "$lang" in
    go)
      go build -o "$INSTALL_DIR/$name"
      ;;
    rust)
      cargo build --release
      cp "target/release/$name" "$INSTALL_DIR/$name"
      ;;
    make)
      make
      cp "$name" "$INSTALL_DIR/$name"
      ;;
  esac

  popd >/dev/null
  rm -rf "$tmp"
}

# 📦 Applications
build_from_git "jesseduffield/lazygit" "lazygit" "go"
build_from_git "jesseduffield/lazydocker" "lazydocker" "go"
build_from_git "sharkdp/bat" "bat" "rust"
build_from_git "sharkdp/fzf" "fzf" "go"
build_from_git "eza-community/eza" "eza" "rust"
build_from_git "starship/starship" "starship" "rust"
build_from_git "Arcanemagus/atac" "atac" "go"
build_from_git "lazysql/lazysql" "lazysql" "rust"

# 📝 Neovim
install_neovim() {
  echo "📝 Installing Neovim from source..."
  tmp=$(mktemp -d)
  git clone https://github.com/neovim/neovim "$tmp" --depth 1
  pushd "$tmp" >/dev/null
  make CMAKE_BUILD_TYPE=RelWithDebInfo
  make install PREFIX="$INSTALL_DIR"
  popd >/dev/null
  rm -rf "$tmp"
}
if [[ $FORCE -eq 1 || (! -x "$INSTALL_DIR/nvim" && ! command -v nvim &>/dev/null) ]]; then
  install_neovim
else
  echo "🔍 Neovim already installed, skipping"
fi

# 💻 rustup
if [[ $FORCE -eq 1 || ! -x "$HOME/.cargo/bin/rustup" ]]; then
  echo "📦 Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
else
  echo "🔍 Rustup already installed, skipping"
fi

# 🐳 Docker
if [[ $FORCE -eq 1 || (! -x "$(command -v docker)" && -x "$(command -v sudo)") ]]; then
  echo "🐳 Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sudo sh get-docker.sh
  rm get-docker.sh
else
  echo "🔍 Docker already installed or no sudo access, skipping"
fi

# 💻 NVM
if [[ ! -d "$HOME/.nvm" || $FORCE -eq 1 ]]; then
  echo "💻 Installing NVM..."
  version=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${version}/install.sh" | bash
else
  echo "🔍 NVM already installed, skipping"
fi

# 📁 rupa/z
if [[ ! -f "$HOME/.local/lib/z/z.sh" || $FORCE -eq 1 ]]; then
  echo "📁 Installing rupa/z..."
  mkdir -p "$HOME/.local/lib/z"
  git clone https://github.com/rupa/z.git "$HOME/.local/lib/z" --depth 1
else
  echo "🔍 Rupa/z already installed, skipping"
fi

# 🔗 Dotfiles
if command -v stow &>/dev/null; then
  echo "🔗 Linking dotfiles..."
  cd "$(dirname "$0")/stow"
  for dir in */; do
    stow "$dir" -t "$HOME"
  done
fi

# 🪪 bashrc / aliases
ensure_bash_files_sourced() {
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
}

ensure_bash_files_sourced

echo "✅ Setup complete. Binaries in: $INSTALL_DIR"

