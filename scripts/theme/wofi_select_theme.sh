command_file=$HOME/dotfiles/scripts/themes.txt

selection=$(cat "$command_file" | wofi --dmenu --prompt="Select Theme:")

if [ -n "$selection" ]; then
	$HOME/dotfiles/scripts/theme.sh "$selection"
fi
