# 🛠️ Dotfiles: Nix + Home Manager + Stow + Custom Setup Script

This is my developer environment configured automatically using:

- 🧊 [Nix](https://nixos.org/)
- 🏠 [Home Manager](https://nix-community.github.io/home-manager/)
- 📦 [GNU Stow](https://www.gnu.org/software/stow/)
- ⚙️ Custom setup script [`setup.sh`](./setup.sh)

---

## 🔁 Installation

1. Clone the repository:

```bash
git clone https://github.com/your-username/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Run the setup script:

```bash
./setup.sh
```

To force reinstallation and update all packages, use:

```bash
./setup.sh --force
```

---

## 🧩 Structure

```
.
├── flakes.nix          # Nix Flakes configuration with Home Manager
├── home/
│   └── default.nix     # Home Manager module with user environment config
├── stow/               # Dotfiles managed by GNU Stow
├── setup.sh            # Custom bootstrap script to build and install tools from source
├── .bash_aliases       # Custom shell aliases sourced by shell profiles
├── .bashrc_custom      # Additional custom shell configuration sourced by shell profiles
└── README.md           # This documentation
```

---

## ⚙️ Details

- Most CLI tools like `lazygit`, `bat`, `fzf`, `starship`, `neovim`, `docker` etc. are built **from source** by `setup.sh`.
- Nix and Home Manager provide system-level packages and configuration.
- GNU Stow manages symlinks for dotfiles.
- The setup script automatically detects your username and home directory, so no manual edits are required.
- Shell profiles (`.bashrc` or `.bash_profile`) are automatically configured to source `.bash_aliases` and `.bashrc_custom` located next to the dotfiles.

---

## 🛠️ Usage

- After running `setup.sh`, you should have all necessary CLI tools installed in `~/.local/bin`.
- Make sure `~/.local/bin` is in your `PATH`.
- Use Nix Flakes commands like:

```bash
nix run
home-manager switch
```

to manage your environment declaratively.

---

## 📚 References

- [Nix Official](https://nixos.org/)
- [Home Manager](https://nix-community.github.io/home-manager/)
- [GNU Stow](https://www.gnu.org/software/stow/)
- [Setup Script](./setup.sh) — builds and installs tools from sources

---

Feel free to customize and extend!

---

If you want me to generate or update any other documentation or scripts, just ask.
