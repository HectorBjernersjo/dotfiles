#!/usr/bin/env bash
# Given a file with pane targets (one per line), outputs "target\tstatus" lines
# sorted with "working" first. Takes 5 snapshots 0.05s apart.

pane_file="$1"

declare -A working

# Snapshot 1
declare -A prev
while read -r target; do
  [[ -z "$target" ]] && continue
  prev[$target]=$(tmux capture-pane -t "$target" -p)
done < "$pane_file"

# Snapshots 2-5: compare each to previous
for i in 1 2 3 4; do
  sleep 0.05
  while read -r target; do
    [[ -z "$target" ]] && continue
    [[ "${working[$target]}" == "1" ]] && continue
    snap=$(tmux capture-pane -t "$target" -p)
    if [[ "${prev[$target]}" != "$snap" ]]; then
      working[$target]=1
    fi
    prev[$target]="$snap"
  done < "$pane_file"
done

# Output: working first, then idle
while read -r target; do
  [[ -z "$target" ]] && continue
  if [[ "${working[$target]}" == "1" ]]; then
    echo -e "$target\tworking"
  fi
done < "$pane_file"

while read -r target; do
  [[ -z "$target" ]] && continue
  if [[ "${working[$target]}" != "1" ]]; then
    echo -e "$target\tidle"
  fi
done < "$pane_file"
