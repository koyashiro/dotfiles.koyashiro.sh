#!/usr/bin/env sh

set -eu

set_variables() {
  readonly DEFAULT_DOTDIR="$HOME/.dotfiles"
  if [ -z "${DOTDIR:-}" ]; then
    DOTDIR="$DEFAULT_DOTDIR"
  fi

  readonly DEFAULT_REPO_URL=https://github.com/koyashiro/dotfiles
  if [ -z "${REPO_URL:-}" ]; then
    REPO_URL="$DEFAULT_REPO_URL"
  fi
}

check_dotdir() {
  printf "\x1b[32mChecking\x1b[37m %s\n" "$DOTDIR"

  if [ -d "$DOTDIR" ]; then
    printf "\x1b[31mError:\x1b[37m %s already exists\n" "$DOTDIR" 1>&2
    exit 1
  fi

  echo "  $DOTDIR does not exists"
}

clone_dotfiles() {
  if command -v git >/dev/null 2>&1; then
    printf "\x1b[32mCloning\x1b[37m %s\n" "$REPO_URL"
    git clone "$REPO_URL" "$DOTDIR" >/dev/null 2>&1
    echo "  Cloned to $DOTDIR"
  else
    printf "\x1b[31mError:\x1b[37m git command not found\n" 1>&2
    exit 127
  fi
}

install_dotfiles() {
  printf "\x1b[32mExecute\x1b[37m %s\n" "$DOTDIR/install.sh"
  "$DOTDIR/install.sh"
}

main() {
  set_variables

  check_dotdir

  clone_dotfiles

  install_dotfiles
}

main
