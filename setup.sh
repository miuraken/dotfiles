#!/bin/sh

# if stow is not installed
if ! command -v stow >/dev/null 2>&1; then
  if command -v apt >/dev/null 2>&1; then
    sudo apt update
    sudo apt install -y stow tmux
  elif command -v yum >/dev/null 2>&1; then
    sudo yum install -y stow tmux
  elif command -v brew >/dev/null 2>&1; then
    brew install stow tmux
  else
    echo "Neither apt, yum, brew found."
    exit 1
  fi
  if ! command -v stow >/dev/null 2>&1; then
    echo "🔥 stowのインストールに失敗しました。"
    exit 1
  fi
fi

SCRIPT_PATH=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "${SCRIPT_PATH}")
stow -R -v -d "${SCRIPT_DIR}" -t ~ zsh emacs tmux ssh

exit 0