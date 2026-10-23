# Sourced by install.sh. Not meant to be executed.

# $1 command to look for; $2 brew formula and $3 apt package default to $1.
# Uses pkg_manager from the caller: brew, apt, or empty.
ensure_package() {
  command="$1"
  brew_formula="${2:-$1}"
  apt_package="${3:-$1}"
  if type "$command" > /dev/null 2>&1; then
    return 0
  fi
  if [ -z "$pkg_manager" ]; then
    return 0
  fi
  echo "Installing $command..."
  if [ "$pkg_manager" = brew ]; then
    brew install -y "$brew_formula"
  else
    sudo apt install -y "$apt_package"
  fi
  echo "...$command installation complete!"
}

# asdf shims follow cwd; install.sh has already cd'd into the repo.
run_from_home() {
  (cd "$HOME" && "$@")
}

run_if_present() {
  label="$1"
  shift
  cmd="$1"
  if ! type "$cmd" > /dev/null 2>&1; then
    echo "$cmd not on PATH; skipped $label."
    return 0
  fi
  echo "Running $label..."
  if ! run_from_home "$@"; then
    echo "...$label failed!" >&2
    exit 1
  fi
  echo "...$label complete!"
}
