#!/usr/bin/env bash

# List tmux sessions and select one using fzf
sess=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0)
echo $sess
tmux switch -t "$sess"

#!/usr/bin/env bash

# Create a temporary script to run fzf inside a new tmux window
TEMP_SCRIPT=$(mktemp)
cat << 'EOF' > $TEMP_SCRIPT
#!/usr/bin/env bash

sess=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0)
echo $sess
tmux switch -t "$sess"
tmux kill-window
EOF

# Make the temporary script executable
chmod +x $TEMP_SCRIPT

# Run the temporary script in a new tmux window
tmux new-window -n fzf-session -d "$TEMP_SCRIPT && rm -f $TEMP_SCRIPT"
tmux select-window -t fzf-session
