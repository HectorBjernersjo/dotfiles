#!/usr/bin/env bash

# If we're already inside tmux, just start a login shell
if [ -n "$TMUX" ]; then
  exec /bin/zsh -l
fi

# Otherwise attach/create a persistent session
exec tmux new-session -A -s default
