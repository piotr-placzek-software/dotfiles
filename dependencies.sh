#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
mkdir -p "$INSTALL_DIR"

# 📦 Nix + Flakes
if ! command -v nix &>/dev/null; then
  echo "🔧 Installing Nix..."

  mkdir -p $HOME/.config/nix
  echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf

  if [ ! -d /nix/store ]; then
    echo "📁 Creating /nix with sudo..."
    sudo mkdir -m 0755 /nix
    sudo chown "$USER" /nix
  fi

  curl -L https://nixos.org/nix/install | bash
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# 🔧 Enable experimental features globally (for root too)
if [ -w /etc/nix ]; then
  echo "🧩 Ensuring flakes are enabled globally..."
  echo 'experimental-features = nix-command flakes' | sudo tee /etc/nix/nix.conf > /dev/null
else
  echo "ℹ️ Warning: could not write to /etc/nix; flakes may not work with sudo"
fi

echo "📦 Installing dev tools..."
nix profile install nixpkgs#stow nixpkgs#wget nixpkgs#gnumake nixpkgs#cmake nixpkgs#gcc nixpkgs#glibc nixpkgs#ncurses  # nixpkgs#go nixpkgs#rustup
nix profile install nixpkgs#curl nixpkgs#gnutar nixpkgs#jq nixpkgs#openssh
# nix profile install nixpkgs#ca-certificates

# ✅ Ensure ~/.nix-profile/bin is in PATH
if ! echo "$PATH" | grep -q "$HOME/.nix-profile/bin"; then
  echo "📁 Adding ~/.nix-profile/bin to PATH in ~/.bashrc..."
  echo 'export PATH="$HOME/.nix-profile/bin:$PATH"' >> "$HOME/.bashrc"
fi

export PATH="$HOME/.nix-profile/bin:$PATH"

echo "✅ Dependencies setup by nix complete."
