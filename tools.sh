#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"

# 💻 rustup
if [[ ! -x "$HOME/.cargo/bin/rustup" ]]; then
  echo "📦 Installing rustup..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  . "$HOME/.cargo/env"

  if ! grep -qF "$HOME/.cargo/env" "$HOME/.bashrc"; then
    echo "📁 Adding ~/.cargo/env to ~/.bashrc..."
    echo ". \"$HOME/.cargo/env\"" >> "$HOME/.bashrc"
  fi
else
  echo "🔍 Rustup already installed, skipping"
fi

# 🐹 Go
if [[ ! -x "$(command -v go)" ]]; then
  echo "🐹 Installing latest Go (x86_64 only)..."
 
  GO_LATEST=$(curl -s https://go.dev/VERSION?m=text | head -n 1)
  echo "📦 Latest Go version: $GO_LATEST"

  curl -LO "https://go.dev/dl/${GO_LATEST}.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "${GO_LATEST}.linux-amd64.tar.gz"
  rm "${GO_LATEST}.linux-amd64.tar.gz"

  if ! echo "$PATH" | grep -q "/usr/local/go/bin"; then
    echo "📁 Adding ~/.cargo/env to ~/.bashrc..."
    echo 'export PATH="/usr/local/go/bin:$PATH"' >> "$HOME/.bashrc"
  fi
  export PATH="/usr/local/go/bin:$PATH"
else
  echo "🔍 Go already installed, skipping"
fi

# 📝 Neovim
NVIM_BIN="$INSTALL_DIR/nvim-linux-x86_64"
if [[ (! -x "$NVIM_DIR/nvim" && ! "$(command -v nvim &>/dev/null)") ]]; then
  latest=$(curl -s https://api.github.com/repos/neovim/neovim/releases/latest | jq -r '.tag_name')
  echo "📝 Installing Neovim: $latest"
  url="https://github.com/neovim/neovim/releases/download/${latest}/nvim-linux-x86_64.tar.gz"
  tmp=$(mktemp -d)
  curl -L "$url" -o "$tmp/nvim.tar.gz"
  tar -xzf "$tmp/nvim.tar.gz" -C "$INSTALL_DIR"
  rm -rf "$tmp"
  if ! grep -q "$NVIM_BIN/bin" "$HOME/.bashrc"; then
    echo "🛠 Updating ~/.bashrc to include Neovim..."
    echo "export PATH=\"$NVIM_BIN/bin:\$PATH\"" >> "$HOME/.bashrc"
  fi
  export PATH="$NVIM_BIN/bin:$PATH"
else
  echo "🔍 Neovim already installed, skipping"
fi


# 🐳 Docker
if [[ "$(uname -s)" == "Linux" ]]; then
  if grep -qi arch /etc/os-release 2>/dev/null; then
    echo "🐳 Installing Docker on Arch Linux using pacman..."
    if command -v sudo &>/dev/null; then
      sudo pacman -Syu --noconfirm docker
      sudo systemctl start docker
      sudo systemctl enable docker
    else
      echo "❌ No sudo found, cannot install Docker"
    fi
  else
    if [[ ! -x "$(command -v docker)" && -x "$(command -v sudo)" ]]; then
      echo "🐳 Installing Docker..."
      curl -fsSL https://get.docker.com -o get-docker.sh
      sudo sh get-docker.sh
      rm get-docker.sh
    else
      echo "🔍 Docker already installed or no sudo access, skipping"
    fi
  fi
else
  echo "ℹ️ Docker install script only supports Linux"
fi

# 💻 NVM
if [[ ! -d "$HOME/.nvm" ]]; then
  echo "💻 Installing NVM..."
  version=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | jq -r .tag_name)
  curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${version}/install.sh" | bash
else
  echo "🔍 NVM already installed, skipping"
fi

# 📁 rupa/z
if [[ ! -f "$HOME/.local/lib/z/z.sh" ]]; then
  echo "📁 Installing rupa/z..."
  mkdir -p "$HOME/.local/lib/z"
  git clone https://github.com/rupa/z.git "$HOME/.local/lib/z" --depth 1
else
  echo "🔍 Rupa/z already installed, skipping"
fi

# 🔨 Building form github sources
build_from_git() {
  repo="$1"
  name="$2"
  lang="$3"

  if command -v "$name" &>/dev/null || [[ -x "$INSTALL_DIR/$name" ]]; then
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

echo "✅ Tools setup complete."
