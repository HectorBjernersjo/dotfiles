#!/usr/bin/env bash
# Shared picker for claude pane scripts.
# Reads pane targets from stdin, shows fzf with status + preview, switches to selection.

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/.envs"

header="${1:-Claude Code panes (ctrl-r to refresh preview)}"

claude_panes=$(cat | sed '/^[[:space:]]*$/d')

if [[ -z "$claude_panes" ]]; then
  tmux display-message "No Claude Code panes found."
  exit 0
fi

tmpfile=$(mktemp /tmp/claude-panes-XXXXXX)
echo "$claude_panes" > "$tmpfile"
trap "rm -f '$tmpfile'" EXIT

preview_cmd="tmux capture-pane -t {1} -p -e -S - -E -"
status_cmd="$CURRENT_DIR/claude-status.sh $tmpfile | column -t -s $'\t'"

selected=$(echo "$claude_panes" \
  | fzf-tmux \
    -p '90%,80%' \
    --layout=reverse \
    --ansi \
    --delimiter=' +' \
    --preview "$preview_cmd" \
    --preview-window 'right,75%,follow,~0' \
    --bind "start:reload:$status_cmd" \
    --bind 'ctrl-r:refresh-preview' \
    --header "$header")

[[ -z "$selected" ]] && exit 0

target=$(echo "$selected" | awk '{print $1}')
tmux switch-client -t "$target"
