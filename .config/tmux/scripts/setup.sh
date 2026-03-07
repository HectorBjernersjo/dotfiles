#!/usr/bin/env bash

# The directory where tpm is expected to be
TPM_DIR="$HOME/.tmux/plugins/tpm"

# A helper function to print messages
log() {
  echo "=> $1"
}

# --- Main Script ---

# 1. Check for tpm and clone if it doesn't exist
if [ ! -d "$TPM_DIR" ]; then
  log "Cloning tpm from GitHub..."
  git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
else
  log "tpm is already installed."
fi

# 2. Install plugins
# This command sources the tpm installer script, which then reads your .tmux.conf
# and installs any missing plugins.
log "Installing tmux plugins..."
"$TPM_DIR/bin/install_plugins"

log "✅ Tmux setup complete. You can now start tmux."
