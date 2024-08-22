command_file=$HOME/dotfiles/scripts/themes.txt

selection=$(cat "$command_file" | wofi --dmenu --prompt="Select Theme:")

$HOME/dotfiles/scripts/theme.sh "$selection"
