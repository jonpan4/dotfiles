#!/bin/sh
# Ona-specific installation steps, aggregated here so install.sh stays
# readable.

ona_dir="$(dirname "$0")"

# --- Ona remote ownership watchers ------------------------------------------

echo "Starting Ona remote ownership watchers..."
bash "$ona_dir/fix-ona-remote-ownership.sh"
echo "...Ona remote ownership watchers running!"

# Agent shells skip .zshrc; append Ona secrets loading to .zshenv once, preserving existing contents.
if [ -f /etc/profile.d/ona-secrets.sh ]; then
  ona_secrets_line='. /etc/profile.d/ona-secrets.sh'
  if ! grep -Fqx "$ona_secrets_line" "$HOME/.zshenv" 2>/dev/null; then
    printf '\n%s\n' "$ona_secrets_line" >> "$HOME/.zshenv" || exit 1
  fi
fi
