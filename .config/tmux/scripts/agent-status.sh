#!/usr/bin/env bash
# Given a file with pane targets (one per line), outputs "target\tstatus\tagent" lines.
# Codex uses an explicit "esc to interrupt" marker; Claude uses pane motion.

pane_file="$1"
CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$CURRENT_DIR/agent-pane-match.sh"

declare -A status
declare -A agent_type
declare -A pane_title
declare -A initial_content

while read -r target; do
  [[ -z "$target" ]] && continue
  pane_meta=$(tmux display-message -p -t "$target" "#{pane_current_command}	#{pane_title}")
  pane_cmd=${pane_meta%%$'\t'*}
  pane_title[$target]=${pane_meta#*$'\t'}
  agent_type[$target]=$(detect_agent_type "$pane_cmd" "${pane_title[$target]}" || echo "unknown")
  initial_content[$target]=$(tmux capture-pane -t "$target" -p)

  if [[ "${agent_type[$target]}" == "codex" ]]; then
    if is_codex_running "${initial_content[$target],,}"; then
      status[$target]="running"
    else
      status[$target]="idle"
    fi
  else
    status[$target]="unknown"
  fi
done < "$pane_file"

fallback_targets=()
while read -r target; do
  [[ -z "$target" ]] && continue
  [[ "${status[$target]}" == "unknown" ]] && fallback_targets+=("$target")
done < "$pane_file"

if [[ ${#fallback_targets[@]} -gt 0 ]]; then
  sleep 0.2

  for target in "${fallback_targets[@]}"; do
    snap=$(tmux capture-pane -t "$target" -p)
    if [[ "${initial_content[$target]}" != "$snap" ]]; then
      status[$target]="running"
    else
      status[$target]="idle"
    fi
  done
fi

# Output: running first, then idle
while read -r target; do
  [[ -z "$target" ]] && continue
  if [[ "${status[$target]}" == "running" ]]; then
    echo -e "$target\trunning\t${agent_type[$target]}"
  fi
done < "$pane_file"

while read -r target; do
  [[ -z "$target" ]] && continue
  if [[ "${status[$target]}" == "idle" ]]; then
    echo -e "$target\tidle\t${agent_type[$target]}"
  fi
done < "$pane_file"
