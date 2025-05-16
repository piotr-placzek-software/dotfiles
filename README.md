# 🛠️ Dotfiles: Nix  + Stow + Custom Setup Script

This is my developer environment configured automatically using:

- 🧊 [Nix](https://nixos.org/)
- 📦 [GNU Stow](https://www.gnu.org/software/stow/)
- ⚙️ Custom setup script [`setup.sh`](./setup.sh)

---

## 🔁 Installation

> GIT: <br/>
> Support for password authentication was removed on August 13, 2021.
> Please see https://docs.github.com/get-started/getting-started-with-git/about-remote-repositories#cloning-with-https-urls for information on currently recommended modes of authentication.

1. Clone the repository:

```bash
git clone https://github.com/piotr-placzek-software/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

2. Run the setup script:

```bash
./setup.sh
```

---

## ⚙️ Details

- Most CLI tools like `lazygit`, `bat`, `fzf`, `starship`, `neovim`, `docker` etc. are built **from source**.
- GNU Stow manages symlinks for dotfiles.
- The setup script automatically detects your username and home directory, so no manual edits are required.
- Shell profiles (`.bashrc` or `.bash_profile`) are automatically configured to source `.bash_aliases` and `.bashrc_custom` located next to the dotfiles.

---

## 🛠️ Usage

- After running `setup.sh`, you should have all necessary CLI tools installed in `~/.local/bin`.
- Make sure `~/.local/bin` is in your `PATH`.

---

## 📚 References

- [Nix Official](https://nixos.org/)
- [GNU Stow](https://www.gnu.org/software/stow/)

