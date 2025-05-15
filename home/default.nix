{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    stow
    wget
    gnutar
    gnupg
    make
    gcc
    glibc
    ncurses
    apt
    curl
    ca-certificates
    mc
  ];

  programs.zsh.enable = true;
  programs.git.enable = true;
  programs.tmux.enable = true;
  programs.starship.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
  };

  home.stateVersion = "24.05";
}

