#!/usr/bin/env bash

detect_agent_type() {
  local cmd="${1:-}"
  local title="${2:-}"
  local cmd_lc="${cmd,,}"
  local title_lc="${title,,}"

  if [[ "$cmd_lc" == *claude* ]] || [[ "$title_lc" == *claude* ]] || [[ "$cmd_lc" == *node* && "$title_lc" == *claude* ]]; then
    echo "claude"
    return 0
  fi

  if [[ "$cmd_lc" == *codex* ]] || [[ "$title_lc" == *codex* ]]; then
    echo "codex"
    return 0
  fi

  return 1
}

matches_agent_pane() {
  local cmd="${1:-}"
  local title="${2:-}"

  detect_agent_type "$cmd" "$title" >/dev/null
}

is_codex_running() {
  local content_lc="${1:-}"
  [[ "$content_lc" == *"esc to interrupt"* ]]
}
